#!bin/sh
#Tach dong header
header=$(csvtool -t ',' col 7,9,14,16,18-21,6 tmdb-movies.csv |  head -n 1)

#Tach rows
  csvtool -t ',' col 7,9,14,16,18-21,6 tmdb-movies.csv | awk -F ',' 'NR > 1' > rows.csv

#1/Sap xep bo phim theo ngay phat hanh
  csvsort -c release_date -r tmdb-movies.csv > sort_by_release_date.csv
#2/Loc ra cac phim co danh gia trung binh > 7.5
  vote=$(csvsql --query 'SELECT * FROM "tmdb-movies" WHERE vote_average > 7.5' tmdb-movies.csv)
  echo "$header" > vote.csv
  echo "$vote" >> vote.csv

#3/Tim ra phim co doanh thu cao nhat va thap nhat
  #Sort Rev Adj by descending
  SortRevAdj=$(awk -F ',' ' $8 > 0' rows.csv | sort -t ',' -k8gr)

  #Highest Rev Adj
  echo "$SortRevAdj" | head -n 1 > HighestRev.csv
  HighestRev=$(csvtool -t ',' col 9,8 HighestRev.csv | awk -F ',' '{print "Movie:"$1 ", Revenue Adjustment:"$2}')
  
  #Lowest Rev Adj
  echo "$SortRevAdj" | tail -n 1 > LowestRev.csv
  LowestRev=$(csvtool -t ',' col 9,8 LowestRev.csv | awk -F ',' '{print "Movie:"$1 ", Revenue Adjustment:"$2}')


  echo "3/Highest Revenue Adjustment:"
  echo "$HighestRev"
 
  echo "  Lowest Revenue Adjustment:"
  echo "$LowestRev"
  echo "---------------------------------------"

#4/Tinh tong doanh thu  
  Total=$(csvtool -t ',' col 8 rows.csv | paste -sd+ | bc)
  echo "4/Total Revenue:"
  echo "$Total"
  echo "---------------------------------------"

#5/Top 10 bo phim co profit cao nhat
  Top10=$(csvtool -t ',' col 7-9 rows.csv | awk -F ',' '{print $3 ", " $2-$1}' | sort -t ',' -k2gr | head -n 10)
  echo "5/Top 10 movies co profit cao nhat"
  echo "Movie, Profit" 
  echo "$Top10"
  echo "---------------------------------------"

#6/Dao dien
  director=$(csvtool -t ',' col 2 rows.csv | grep -v '^[[:space:]]*$' | tr '|' '\n' | sort -r | uniq -c | sort -k1gr | head -n 1 )
  echo "6/Director co nhieu phim nhat"
  echo "$director"

 #dien vien
  act=$(csvtool -t ',' col 1 rows.csv | grep -v '^[[:space:]]*$' | tr '|' '\n' | sort -r | uniq -c | sort -k1gr | head -n 1 )
  echo "  Dien vien dong nhieu phim nhat"
  echo "$act"
  echo "---------------------------------------"

#7/Thong ke theo the loai
  genres=$(csvtool -t ',' col 3 rows.csv | grep -v '^[[:space:]]*$' | tr '|' '\n' | sort -r | uniq -c | sort -k1gr )
  echo "7/Thong ke the loai phim"
  echo "$genres"
  rm rows.csv *Rev.csv 



