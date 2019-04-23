<?php

$files = glob('data/TAXRATES_ZIP5/*.csv');
$rates = [];

foreach ($files as $file) {
    $data = array_map('str_getcsv', file($file));

    array_shift($data);

    $regionalRates = [
        'region' => $data[0][0],
        'rate'   => (double) $data[0][3],
        'localRates' => [],
    ];

    foreach ($data as $rate) {
        $regionalRates['localRates'][] = [
            'zip' => $rate[1],
            'rate' => (double) $rate[4],
        ];
    }

    $rates[] = $regionalRates;
}

file_put_contents('us-rates.json', json_encode($rates,  JSON_PRETTY_PRINT));
