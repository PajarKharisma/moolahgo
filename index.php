<?php

class Connection
{
    public function mysqlConnection()
    {
        $servername = "localhost";
        $username = "root";
        $password = "";
        $dbname = "moolahgo";

        try {
            $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
            $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            return $conn;
        } catch (PDOException $e) {
            echo "Connection failed: " . $e->getMessage();
        }
    }
}

class UpdateTransaction
{
    private $conn;
    private $savedRemitCount = 0;
    private $savedBankInCount = 0;
    private $savedLastRemitId = -1;
    private $savedLastBankInId = -1;

    function __construct()
    {
        $connection = new Connection();
        $this->conn = $connection->mysqlConnection();
    }

    private function checkNewData()
    {
        $remitResult = $this->conn->query('SELECT transaction_id FROM remit_transaction ORDER BY transaction_id DESC')->fetchAll();
        $bankInResult = $this->conn->query('SELECT bank_in_id FROM incoming_transaction ORDER BY bank_in_id DESC')->fetchAll();

        $remitCount = count($remitResult);
        $bankInCount = count($bankInResult);

        $remitLastId = $remitCount > 0 ? $remitResult[0]['transaction_id'] : -1;
        $bankInLastId = $bankInCount > 0 ? $bankInResult[0]['bank_in_id'] : -1;

        if (($remitCount != $this->savedRemitCount) || ($remitLastId != $this->savedLastRemitId) || ($bankInCount != $this->savedBankInCount) || ($bankInLastId != $this->savedLastBankInId)) {
            $this->savedRemitCount = 0;
            $this->savedBankInCount = 0;
            $this->savedLastRemitId = -1;
            $this->savedLastBankInId = -1;
            return true;
        } else {
            return false;
        }
    }

    public function updateData()
    {
        if ($this->checkNewData()) {
            $sql = "SELECT it.bank_in_id, rt.transaction_id
                FROM `incoming_transaction` AS it, remit_transaction AS rt
                WHERE it.bank_in_amount = rt.transaction_expected_amount
                AND it.bank_in_currency = rt.transaction_expected_currency
                AND it.bank_in_transaction_reference = rt.transaction_reference_number
                AND rt.transaction_financial_status='unpaid'
                AND rt.transaction_processing_status='pending'
                AND it.bank_in_status='pending'";

            $result = $this->conn->query($sql)->fetchAll();

            if (count($result) > 0) {
                $remitIds = join(',', array_column($result, 'transaction_id'));
                $bankInIds = join(',', array_column($result, 'bank_in_id'));

                $queryUpdate1 = "UPDATE remit_transaction SET transaction_financial_status='paid', transaction_processing_status='completed' WHERE transaction_id IN ($remitIds)";
                $stmt = $this->conn->prepare($queryUpdate1);
                $stmt->execute();

                $queryUpdate2 = "UPDATE incoming_transaction SET bank_in_status='matched' WHERE bank_in_id IN ($bankInIds)";
                $stmt = $this->conn->prepare($queryUpdate2);
                $stmt->execute();
            }
        }
    }
}

$updateTransaction = new UpdateTransaction();
$updateTransaction->updateData();
