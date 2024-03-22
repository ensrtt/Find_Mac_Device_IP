# Find_Mac_Device_IP
Bu PowerShell scripti, belirli bir IP aralığındaki ağ cihazlarını taramak ve belirli bir MAC adresine sahip olan cihazı bulmak için tasarlanmıştır. 

# 🚀 Neden Bu Kadar Cool Bir Script Yazdım? 🛠️
Atölyemde 3B Yazıcılar, CNC'ler, IP Kameralar ve adını bile hatırlamadığım bir sürü IOT cihaz var. 🤖 Static IP'm yok, port yönlendirme? Nope, güvenlik risklerinden dolayı bana uzak. Her bilgisayarımı açışımda, bu cool projelerime ve cihazlarıma ulaşmak için modem arayüzüne dalıp, bir sürü IP arasından doğru cihazı bulmak... Uff, çok iş yani. 😩

Ben de dedim ki, "Bu işler olacak iş değil, ben bir şeyler yapmalıyım." Ve işte karşınızda, belki de dünyayı değiştirmeyecek ama benim gibi tatlı ve tembel hobi atölyecilerinin hayatını kurtaracak bir PowerShell scripti! 🌟

Bu proje o kadar basit ki, belki "Bunu yayınlamaya değer mi?" diye düşünebilirsiniz. Ama bilin ki, evrende benim gibi tatlı ve tembel hobi atölyecileri var ve belki bu proje, onlara "Aha, işte bu!" dedirtecek. 🎉

Kısacası, bu script atölyemdeki tüm o cool cihazlara, adeta bir ninja gibi, sessizce ve hızla ulaşmamı sağlıyor. Bilgisayarı aç, bir klikle tüm cihazlar avucunun içinde. Hayat bu kadar kolay olmalı. 🥳

Not: Bu scripti kullanırken kendi sorumluluğunuzda olduğunuzu unutmayın. Ama bence biraz risk almak hayatı heyecanlı kılar, değil mi? 😉 İyi taramalar dilerim, eğlencenin tadını çıkarın! 🚀

# Ağ Cihazlarını Tarama ve MAC Adresi Bulma Scripti
## Genel Bakış
Bu PowerShell scripti, belirli bir IP aralığındaki ağ cihazlarını taramak ve belirli bir MAC adresine sahip olan cihazı bulmak için tasarlanmıştır. Script, belirtilen IP aralığındaki tüm cihazları asenkron olarak pingler, başarılı yanıtları alınan cihazların IP ve MAC adreslerini listeler. Ayrıca, sistemdeki ARP (Address Resolution Protocol) tablosunu kullanarak IP ve MAC adreslerini eşler ve belirtilen bir MAC adresine sahip cihazın IP adresini bulur. Son olarak, bulunan IP adresine sahip cihazın web arayüzüne Chrome tarayıcısı üzerinden erişim sağlar.

## Kurulum Gereksinimleri
- Windows işletim sistemi.
- PowerShell 5.1 veya üzeri
- Chrome

## Kullanım

### Yöntem 1- .bat ile 
Eğer .bat ve .ps1 aynı dizindeyse doğrudan .bat dosyasını çalıştırarak başlatabilirsiniz. 
Eğer aynı dizinde değillerse:
1. Script ile birlikte gelen .bat uzantılı dosya içerisindeki .ps1 scripti için belirtilen dosya yolunu düzenleyin.
2. .bat uzantılı dosyayı direk çalıştırın

### Yöntem 2- PowerShell ile #
1. Script'i çalıştırabileceğiniz bir dizine kaydedin.
2. PowerShell'i yönetici olarak açın.
3. Script'in bulunduğu dizine gidin.
4. Script'i çalıştırmak için aşağıdaki komutu kullanın:

`.\Find_Mac_Device_IP.ps1`

5. Script, 192.168.1.2-254 IP aralığındaki cihazları tarayacağını belirten bir uyarı mesajı gösterir. Devam etmek için "OK" butonuna tıklayın.
6. Tarama işlemi tamamlandığında, başarılı şekilde ping alınan cihazların IP ve MAC adresleri konsola yazdırılır.
7. Eğer aradığınız MAC adresine sahip bir cihaz bulunursa, ilgili cihazın IP adresi Chrome tarayıcısında açılır.

### IP Tarama Aralğını değiştirme 
1. .ps1 uzantılı dosyayı not defteri ya da başka bir düzenleyici ile açın.
2. Aşağıdaki kısımda bulunan ipRange 2..254 değerini değiştirerek istediğiniz aralığı belirtin.
```
# Belirlenen IP aralığında ağ cihazlarını tarama işlemi başlar.
# Taramak istediğiniz IP aralığını belirtin.
$ipRange = 2..254	# Bu örnekte, 192.168.1.2'den 192.168.1.254'e kadar olan cihazlar taranacaktır.
```
3. Dosyayı kaydedip çalıştırın.

### Hedeflenen cihazın MAC adresini Değiştirme
1. .ps1 uzantılı dosyayı not defteri ya da başka bir düzenleyici ile açın.
2. Aşağıdaki kısımda bulunan targetMacAddress fc-ee-91-00-8a-e7 değerini değiştirerek istediğiniz aralığı belirtin.
```
# Aranacak hedef MAC adresi
$targetMacAddress = "fc-ee-91-00-8a-e7".ToLower()
```
3. Dosyayı kaydedip çalıştırın.

## Özellikler
- Asenkron IP taraması.
- ARP tablosu üzerinden MAC adreslerini eşleştirme.
- Belirli bir MAC adresine sahip cihazın web arayüzüne erişim.

## Bilinen Sorunlar
- Script, çalıştırıldığı ağ ortamına ve o anki ağ trafiğine bağlı olarak farklı sonuçlar verebilir.
- Bazı antivirüs veya güvenlik duvarı ayarları, script'in düzgün çalışmasını engelleyebilir.

## Lisans
Bu script, MIT Lisansı altında lisanslanmıştır.

## Katkıda Bulunma
Bu projeye katkıda bulunmak istiyorsanız, lütfen pull request gönderin veya varsa sorunları issue tracker üzerinden bildirin.
