require "csv"
require "json"

# ヒートマップ的なカラーコード値を生成
def gen_color(val, max)
  i = ((val.to_f / max.to_f ) * 255).to_i
  r = case i
    when 0..127 then 0
    when 128..190 then (i - 127) * 4
    else 255
  end
  g = case i
    when 0..63 then i * 4
    when 64..191 then 255
    else 256 - (i - 191) * 4
  end
  b = case i
    when 0..64 then 255
    when 65..126 then 255 - (i - 64) * 4
    else 0
  end
  sprintf("#%02x%02x%02x", r, g, b)
end

# 都道府県別人口をロード
populations = CSV.read("./populations.csv").to_h
max_population = populations.to_a.map{|i| i[1].to_i}.max

# 都道府県ポリゴンをロード
japan = JSON.load(File.open("./japan.geojson"))

# 人口とポリゴンをマージ
japan["features"].delete_if {|feature| feature["properties"]["name"].nil? }
japan["features"].each {|feature|
  if feature["properties"]["name"] == "Shizuoka" # 静岡だけname_localが空...
    name = "静岡"
  else
    name = feature["properties"]["name_local"].sub(/[県都府]$/, '')
  end
  population = populations[name].to_i
  feature["properties"] = {
    name: name,
    color: gen_color(population, max_population),
    population: population,
    population_height: ((population.to_f / max_population.to_f) * 65535).to_i
  }
}
puts japan.to_json
