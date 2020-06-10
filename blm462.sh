#!/bin/bash
echo -e "\nMerhaba. DDoS'a karşı önlem almak için tasarlanmış blm 462 aracına hoşgeldiniz.\n"
echo "    __    __             __ __  ________"
echo "   / /_  / /___ ___     / // / / ___/__ \ "
echo "  / __ \/ / __  __ \   / // /_/ __ \__/ /"
echo " / /_/ / / / / / / /  /__  __/ /_/ / __/ "
echo -e "/____/_/_/ /_/ /_/     /_/  \____/____/\n"

if [[ $EUID -ne 0 ]]; then
       echo -e "Bu programı çalıştırmak için yönetici yetkilerine ihtiyacınız var. Lütfen root yetkileriyle çalıştırınız.\n"
       exit 1
fi

echo -e "Programı sonlandırmak için 0'a basınız.\n"
echo -e "Önlem almak istediğiniz saldırı için anahtarı girin:\n\tSYN : SYN Flood\n\tSL : Slowloris (Slow Header Attack)\n\tR : R.U.D.Y. (Slow Body Attack)\n"

while [[ $input != 0 ]]
do
       	read -r input
       	case $input in
		0)
			echo -e "Çıkmak istediniz.\n"
			exit 1
			;;
		SYN)
			iptables -N syn_flood 2>/dev/null
			iptables -A INPUT -p tcp --syn -j syn_flood 2>/dev/null
			iptables -A syn_flood -m limit --limit 1/s --limit-burst 3 -j RETURN 2>/dev/null
			iptables -A syn_flood -j DROP 2>/dev/null
			echo -e "Saldırı amacıyla gönderilen SYN paketleri bundan sonra filtrelenecek. Yapılan değişikliklerin cihazınıza kalıcı olarak eklenmesini istiyorsanız K'ye basın. \nÖnlem almak istediğiniz başka bir saldırı türü varsa seçiniz:\nSYN : SYN Flood\n SL : Slowloris (Slow Header Attack)\n R : R.U.D.Y. (Slow Body Attack)\n\nProgramı sonlandırmak için 0'a basınız.\n"
			;;
		SL)
			iptables -A INPUT -m state --state INVALID -j DROP 2>/dev/null
			iptables -A OUTPUT -m state --state INVALID -j DROP 2>/dev/null
			iptables -A FORWARD -m state --state INVALID -j DROP 2>/dev/null
			echo -e "Slow header saldırılarına karşı önlem alındı. Yapılan değişikliklerin cihazınıza kalıcı olarak eklenmesini istiyorsanız K'ye basın. \nÖnlem almak istediğiniz başka bir saldırı türü varsa seçiniz:\nSYN : SYN Flood\n SL : Slowloris (Slow Header Attack)\n R : R.U.D.Y. (Slow Body Attack)\n\nProgramı sonlandırmak için 0'a basınız.\n"
			;;
		R)
			iptables -A INPUT -m state --state INVALID -j DROP 2>/dev/null
			iptables -A OUTPUT -m state --state INVALID -j DROP 2>/dev/null
			iptables -A FORWARD -m state --state INVALID -j DROP 2>/dev/null
			echo -e "Slow body saldırılarına karşı önlem alındı. Yapılan değişikliklerin cihazınıza kalıcı olarak eklenmesini istiyorsanız K'ye basın. \nÖnlem almak istediğiniz başka bir saldırı türü varsa seçiniz:\nSYN : SYN Flood\n SL : Slowloris (Slow Header Attack)\n R : R.U.D.Y. (Slow Body Attack)\n\nProgramı sonlandırmak için 0'a basınız.\n"
			;;
		K)
			iptables-save 2>&1>/dev/null	
			echo -e "Yapılan değişiklikler kaydedilmiştir. Devam etmek istiyorsanız önlemek istediğiniz saldırının anahtarını girin (SYN Flood için SYN, Slowloris için SL, R.U.D.Y. için R). Çıkmak istiyorsanız 0'a basın.\n"		
			;;
	esac
done

