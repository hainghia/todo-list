<?php
namespace config;

class Database
{
    private $conn;

    public function __construct()
    {
        // Thông tin kết nối database
        $host = getenv('DB_HOST');
        $port = getenv('DB_PORT');
        $dbname = getenv('DB_NAME');
        $user = getenv('DB_USER');
        $password = getenv('DB_PASSWORD');

        // Kết nối database
        $this->conn = pg_connect("host=localhost port=5432 dbname=todo user=postgres password=ahkvqca0n");

        // Kiểm tra kết nối
        if (!$this->conn) {
            echo "Kết nối thất bại";
            exit;
        }

        echo "Kết nối thành công";
    }

    public function getConnection()
    {
        return $this->conn;
    }
}
