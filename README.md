# population_3d_demo

mapbox-gl-jsで都道府県別人口のビジュアライゼーション

## demo.html

サンプルコードです。

## japan.geojson

都道府県ポリゴンのGeoJSONファイルです。

Natural Earth からデータを取得し、以下手順で作成しています。

```
$ curl -LO 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip'
$ unzip ne_10m_admin_1_states_provinces.zip
$ ogr2ogr -f GeoJSON -where 'geonunit = "Japan"' japan.geojson ne_10m_admin_1_states_provinces.shp
```

`ogr2ogr` コマンドは `$ brew install gdal` でインストールしています。

## japan_with_populations.geojson

都道府県ポリゴンと人口をマージしたファイルです。

## merge.rb

japan_with_populations.geojson を生成したスクリプトです。以下のように実行します。

```
$ ruby merge.rb > japan_with_populations.geojson
```

## populations.csv

[e-Stat](https://www.e-stat.go.jp/SG1/estat/eStatTopPortal.do) から取得した都道府県別人口データから手編集で作成したファイルです。元データは以下コマンドで取得可能です。

```
$ curl -O 'http://www.stat.go.jp/data/nihon/zuhyou/n160200200.xls'
```
