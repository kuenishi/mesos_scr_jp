set terminal png transparent size 640,240
set size 1.0,1.0

set terminal png transparent size 640,480
set output 'commits_by_author.png'
set key left top
set yrange [0:]
set xdata time
set timefmt "%s"
set format x "%Y-%m-%d"
set grid y
set ylabel "Commits"
set xtics rotate
set bmargin 6
plot 'commits_by_author.dat' using 1:2 title "Benjamin Hindman" w lines, 'commits_by_author.dat' using 1:3 title "Benjamin Mahler" w lines, 'commits_by_author.dat' using 1:4 title "Vinod Kone" w lines, 'commits_by_author.dat' using 1:5 title "Jie Yu" w lines, 'commits_by_author.dat' using 1:6 title "Neil Conway" w lines, 'commits_by_author.dat' using 1:7 title "Alexander Rukletsov" w lines, 'commits_by_author.dat' using 1:8 title "Anand Mazumdar" w lines, 'commits_by_author.dat' using 1:9 title "Joris Van Remoortere" w lines, 'commits_by_author.dat' using 1:10 title "haosdent huang" w lines, 'commits_by_author.dat' using 1:11 title "Michael Park" w lines, 'commits_by_author.dat' using 1:12 title "Alex Clemmer" w lines, 'commits_by_author.dat' using 1:13 title "Gilbert Song" w lines, 'commits_by_author.dat' using 1:14 title "Joseph Wu" w lines, 'commits_by_author.dat' using 1:15 title "Joerg Schad" w lines, 'commits_by_author.dat' using 1:16 title "Guangya Liu" w lines, 'commits_by_author.dat' using 1:17 title "Timothy Chen" w lines, 'commits_by_author.dat' using 1:18 title "Kapil Arya" w lines, 'commits_by_author.dat' using 1:19 title "Kevin Klues" w lines, 'commits_by_author.dat' using 1:20 title "Jiang Yan Xu" w lines, 'commits_by_author.dat' using 1:21 title "Greg Mann" w lines
