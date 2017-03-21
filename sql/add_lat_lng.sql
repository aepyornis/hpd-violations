UPDATE all_violations SET 
    lat = pluto_16v2.lat, 
    lng = pluto_16v2.lng 
FROM pluto_16v2
WHERE all_violations.bbl = pluto_16v2.bbl;
