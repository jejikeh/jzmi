default_color = {1, 1, 1}
background_color = {0.5, 0.5, 0.5}
water_small_buble = {0.2,0.8,0.5}
water_boost_buble = {0.2,0.8,0.8}
ammo_color = {123, 200, 164}
boost_color = {76, 195, 217}
hp_color = {0.98, 0.3, 0.1}
dp_color = {1,1,0.0}
skill_point_color = {255, 198, 93}
bio_material_color = {0.4,0.9,0.4}

default_colors = {default_color,hp_color,bio_material_color,water_boost_buble,water_small_buble}

negative_colors = {
    {1-default_color[1],1-default_color[2],1-default_color[3]},
    {1-hp_color[1],1-hp_color[2],1-hp_color[3]},
    {1-bio_material_color[1],1-bio_material_color[2],1-bio_material_color[3]},
    {1-water_boost_buble[1],1-water_boost_buble[2],1-water_boost_buble[3]},
    {1-water_small_buble[1],1-water_small_buble[2],1-water_small_buble[3]}
}
    
all_colors = fn.append(default_colors,negative_colors)


score = 0
