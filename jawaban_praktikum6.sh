#!/bin/bash
# jawaban_praktikum6.sh
# Jawaban Praktikum 6 - Manajemen Proses

echo "===== E.1 - Status Proses ====="

echo
echo "a. Nama-nama proses yang bukan root:"
ps -au | awk '$1 != "root" {print $1}' | sort | uniq

echo
echo "b. PID dan COMMAND proses dengan CPU tertinggi:"
ps -aux --sort=-%cpu | head -n 2 | tail -n 1 | awk '{print "PID: " $2 ", COMMAND: " $11}'

echo
echo "c. Buyut proses:"
PID=$(ps -aux --sort=-%cpu | awk 'NR==2 {print $2}')
PPID=$(ps -o ppid= -p $PID)
GPPID=$(ps -o ppid= -p $PPID)
echo "PID Proses: $PID"
echo "PPID: $PPID"
echo "Buyut PPID (PPID dari PPID): $GPPID"

echo
echo "d. Beberapa proses daemon:"
ps -au | awk '$11 ~ /d$/ {print $11}' | sort | uniq

echo
echo "e. Urutan proses dari PID terbesar sampai PPID = 1:"
MAX_PID=$(ps -e --sort=-pid | awk 'NR==2 {print $1}')
echo "PID terbesar: $MAX_PID"
while [ "$MAX_PID" -ne 1 ]; do
    ps -p $MAX_PID -o pid=,ppid=,comm=
    MAX_PID=$(ps -p $MAX_PID -o ppid= | tr -d ' ')
done
echo "Proses utama (PID 1):"
ps -p 1 -o pid=,ppid=,comm=

echo
echo "===== E.2 - prog.sh trap test ====="
cat << 'EOF' > prog.sh
#!/bin/sh
trap "echo Hello Goodbye ; exit 0" 1 2 3 15
echo "Program berjalan …"
while :
do
  echo "X"
  sleep 20
done
EOF

chmod +x prog.sh
echo "prog.sh siap dijalankan: ./prog.sh &"

echo
echo "===== E.3 - myjob.sh trap & hapus file ====="
cat << 'EOF' > myjob.sh
#!/bin/sh
trap "rm -f berkas hasil; echo 'File dihapus'; exit 0" 1 2 3 15
i=1
while :
do
  find / -print > berkas
  sort berkas -o hasil
  echo "Proses selesai pada $(date)" >> proses.log
  sleep 60
done
EOF

chmod +x myjob.sh
echo "myjob.sh siap dijalankan: ./myjob.sh &"

echo
echo "===== Selesai bro! ====="
echo "Jalankan prog.sh dan myjob.sh di background untuk testing trap dan kill."

