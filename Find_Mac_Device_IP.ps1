# Bu kod parçası, ağınızdaki cihazları taramak ve belirli bir MAC adresine sahip cihazı 
# bulmak için güçlü bir araçtır. İlk kısım, belirtilen IP aralığında bulunan tüm cihazları 
# asenkron olarak pingler ve başarılı yanıtlar alanların IP ve MAC adreslerini listeler. 
# İkinci kısım, sistemdeki ARP (Address Resolution Protocol) tablosunu kullanarak IP ve 
# MAC adreslerini eşler ve son olarak, belirtilen bir MAC adresine sahip cihazın IP adresini bulur 
# ve bir web tarayıcısında açar.

#######################################################################################

Write-Host "Find_Mac_Device_IP"
Write-Host "Version 0.12"
Write-Host "FirstPersonSaga"
Write-Host " "


Write-Host "BU KOD, AGINIZDAKI CIHAZLARI TARAMAK VE BELIRLI BIR MAC ADRESINE SAHIP CIHAZI" 
Write-Host "BULMAK ICIN GUCLU BIR ARACTIR."
Write-Host " "
Write-Host "AGINIZDAKI BELIRTILEN ARALIKTAKI IP ADRESLERINI SORGULAR VE MAC ADRESLERINI ESLER."
Write-Host " "
Write-Host "ARADIGINIZ MAC ADRESININ IP ADRESINI"
Write-Host "KULLANARAK CHROME TARAYICISI UZERINDE ILGILI CIHAZIN ARAYUZUNE BAGLANIR." 
Write-Host " "


# System.Windows.Forms namespace'ini yükler
Add-Type -AssemblyName System.Windows.Forms

# Belirlenen IP aralığında ağ cihazlarını tarama işlemi başlar.
# Taramak istediğiniz IP aralığını belirtin.
$ipRange = 2..254	# Bu örnekte, 192.168.1.2'den 192.168.1.254'e kadar olan cihazlar taranacaktır.
$jobs = @()	# Asenkron işlemleri saklamak için boş bir dizi oluşturur.

# Aranacak hedef MAC adresi
$targetMacAddress = "fc-ee-91-00-8a-e7".ToLower()

Write-Host "192.168.1.2-254 ARALIGINDAKI CIHAZLAR TARANACAKTIR"
Write-Host " "

# MessageBox'u göster ve kullanıcının seçimini yakala
$result = [System.Windows.Forms.MessageBox]::Show("192.168.1.2-254 ARALIGINDAKI CIHAZLAR TARANACAKTIR. DEVAM ETMEK ICIN ONAYLAYIN", "TARAMA BASLATMA", [System.Windows.Forms.MessageBoxButtons]::OKCancel, [System.Windows.Forms.MessageBoxIcon]::Information)

# Kullanıcının seçimini değerlendir
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    # Kullanıcı "OK" dediyse, kodun geri kalanını çalıştır
    Write-Host "KULLANICI ONAYLADI, ISLEME DEVAM EDILIYOR..."
    Write-Host " "

    # Tarama işlemini ve diğer işlemleri buraya ekleyin.
} else {
    # Kullanıcı "Cancel" dediyse veya mesaj kutusunu kapattıysa, script'i sonlandır
    Write-Host "KULLANICI IPTAL ETTI, SCRIPT SONLANDIRILIYOR"
    exit
}


# Belirtilen IP aralığındaki her bir IP için asenkron bir şekilde ping işlemi başlatır.
foreach ($i in $ipRange) {
    $ip = "192.168.1.$i"	  # Taranacak IP adresini oluşturur.
    # Test-Connection cmdlet'ini kullanarak IP adresine ping atar ve sonucu bir iş olarak arka planda çalıştırır.
    $jobs += Test-Connection -ComputerName $ip -Count 1 -AsJob -ErrorAction SilentlyContinue
}

Write-Host " "
Write-Host "TARAMA BASLATILDI..."
Write-Host " "
Write-Host "SONUCLAR BEKLENIYOR..."
Write-Host " "


# Tüm işlerin tamamlanmasını bekler ve İşlerin sonuçlarını alır.
$jobs | Wait-Job
$results = $jobs | Receive-Job

# Sonuçları işleyerek başarılı ping yanıtlarını alır ve ilgili IP adreslerinin MAC adreslerini bulur.
foreach ($result in $results) {
    if ($result.StatusCode -eq 0) {	# Eğer ping başarılıysa (StatusCode 0)
        $ip = $result.Address	# Başarılı ping'in IP adresini alır.
        # IP adresine karşılık gelen MAC adresini bulur.
        $mac = Get-NetNeighbor -AddressFamily IPv4 | Where-Object {$_.IPAddress -eq $ip} | Select-Object -ExpandProperty LinkLayerAddress
        # Bulunan IP ve MAC adreslerini ekrana yazdırır.
        Write-Host "IP: $ip, MAC: $mac"
        Write-Host " "

    }
}


# Sistemdeki ARP tablosundan, 192.168.1.* desenine uyan satırları seçer.
$arpTable = arp -a | Select-String -Pattern '192.168.1.'   # ARP tablosunu sorgulayın

# ARP tablosundaki her bir satır için IP ve MAC adreslerini ayıklar ve ekrana yazdırır.
foreach ($line in $arpTable) {
    $ip = $line -replace '\s+', ',' -split ',' | Select-Object -Index 1
    $mac = $line -replace '\s+', ',' -split ',' | Select-Object -Index 2
    Write-Host "IP: $ip, MAC: $mac"
    Write-Host " "

}



# ARP tablosunu al ve hedef MAC adresi için IP adresini bul
$arpResults = arp -a
$found = $false


# ARP tablosundaki her bir satırı kontrol eder.
foreach ($line in $arpResults) {
    if ($line.ToLower() -match $targetMacAddress) {
        # Eğer hedef MAC adresi bulunursa, ilgili IP adresini regex ile ayıklar.
        # IP adresini ayıklama işlemini düzeltilmiş bir regex ile yap
        if ($line -match '\b(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\b') {
            $ip = $matches[1]
            # Bulunan IP adresini ve hedef MAC adresini ekrana yazdırır.
            Write-Host "MAC adresi $targetMacAddress icin bulunan IP: $ip"
            [System.Windows.Forms.MessageBox]::Show("MAC ADRESI $targetMacAddress ICIN BULUNAN IP: $ip", "ARANAN CIHAZ BULUNDU", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            Write-Host "$ip Adresi chrome uzerinde aciliyor."
            # Sistemdeki ARP tablosundan, 192.168.1.* desenine uyan satırları seçer.
            $arpTable = arp -a | Select-String -Pattern '192.168.1.'   # ARP tablosunu sorgulayın

            # Tüm ARP kayıtlarını birleştirmek için boş bir dize oluşturur
            $arpEntries = ""

            # ARP tablosundaki her bir satır için IP ve MAC adreslerini ayıklar ve bir dizeye ekler.
            foreach ($line in $arpTable) {
                $ipbox = $line -replace '\s+', ',' -split ',' | Select-Object -Index 1
                $macbox = $line -replace '\s+', ',' -split ',' | Select-Object -Index 2
                $arpEntries += "IP: $ipbox, MAC: $macbox`n"  # Her kayıt için dizeye ekler ve yeni satıra geçer (`n karakteri ile)
            }

            # Tüm ARP kayıtlarını içeren dizeyi bir mesaj kutusunda gösterir
            [System.Windows.Forms.MessageBox]::Show($arpEntries, "AGDA BULUNAN DIGER CIHAZLAR", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            [System.Windows.Forms.MessageBox]::Show("MAC ADRESI $targetMacAddress ICIN BULUNAN IP: $ip ADRESI CHROME UZERINDE ACILACAKTIR", "ADRES ACILIYOR", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

            Start-Process "chrome" "http://$ip"
            $found = $true
            break
            exit
        }
    }
}

# Eğer hedef MAC adresine ait bir IP adresi bulunamazsa, kullanıcıya bilgi verir.
if (-not $found) {
    Write-Host "MAC adresi $targetMacAddress bulunamadi."
    [System.Windows.Forms.MessageBox]::Show("MAC ADRESI $targetMacAddress OLAN CIHAZ AGDA BULUNAMADI", "CIHAZ BULUNAMADI", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}