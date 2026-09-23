<?php

declare(strict_types=1);

namespace App\Export;

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class PlanTimeExport
{
    protected array $data;
    protected array $headers = [
        'Row No',
        'Time',
        'Distance'
    ];

    public function __construct(array $data)
    {
        $this->data = $data;
    }

    public function export(string $filepath): void
    {
        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();

        // 设置表头
        foreach ($this->headers as $key => $header) {
            $sheet->setCellValue(chr(65 + $key) . '1', $header);
        }

        // 设置数据
        $row = 2;
        foreach ($this->data as $item) {
            $sheet->setCellValue('A' . $row, $item['line']);
            $sheet->setCellValue('B' . $row, $item['duration'] ?? '-');
            $sheet->setCellValue('C' . $row, $item['distince'] ?? '-');
            $row++;
        }

        // 设置列宽
        $sheet->getColumnDimension('A')->setWidth(20);
        $sheet->getColumnDimension('B')->setWidth(20);
        $sheet->getColumnDimension('C')->setWidth(20);

        // 冻结首行
        $sheet->freezePane('A2');

        // 保存文件
        $writer = new Xlsx($spreadsheet);
        $writer->save($filepath);
    }
}