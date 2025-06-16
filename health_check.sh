#!/bin/bash

# ====== Health Check Variables ======
HOSTNAME=$(hostname)
DATE=$(date +"%Y-%m-%d %H:%M:%S")
REPORT="/tmp/health_report.txt"
EMAIL="chandrakanth3103@gmail.com"
SUBJECT="[$HOSTNAME] Health Report - $DATE"

# ====== Start Report ======
echo "📊 Health Report for $HOSTNAME - $DATE" > "$REPORT"
echo "=======================================" >> "$REPORT"

# ----- Uptime -----
echo -e "\n🕒 Uptime:" >> "$REPORT"
uptime >> "$REPORT"

# ----- CPU Usage -----
echo -e "\n🔥 CPU Load:" >> "$REPORT"
top -bn1 | grep "Cpu(s)" >> "$REPORT"

# ----- Memory -----
echo -e "\n💾 Memory Usage:" >> "$REPORT"
free -h >> "$REPORT"

# ----- Disk -----
echo -e "\n🗄 Disk Usage:" >> "$REPORT"
df -h --total >> "$REPORT"

# ----- Running Services -----
echo -e "\n🔧 Active Services:" >> "$REPORT"
for svc in sshd crond docker nginx; do
  systemctl is-active --quiet "$svc" && echo "$svc is ✅ running" || echo "$svc is ❌ not running"
done >> "$REPORT"

# ----- Top Processes -----
echo -e "\n📈 Top 5 Memory-Hungry Processes:" >> "$REPORT"
ps aux --sort=-%mem | head -n 6 >> "$REPORT"

# ====== Send Email ======
cat "$REPORT" | msmtp "$EMAIL"

# Cleanup (optional)
# rm -f "$REPORT"
