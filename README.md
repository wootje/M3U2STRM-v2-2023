# M3U2STRM
Convert your M3U to STRM files for Kodi/Emby on your Linux machine
<br>
<br>
<b>HOW TO USE</b>
<br>
<br>
cd «this directory» && wget «url to m3u8 file» -O vod.m3u8 && ./m3u2strm.sh vod.m3u8 «output directory» «option»
<br>
<br>
<b>Options:</b><br>
1 = local file<br>
2 = url to file
<br>
<br>
<b>Set the output directory on line 196 & 206 in the php file to:</b><br>
«your directory»/movies<br>
«your directory»/tvshows<br>
<br>
<br>
Example crontab (# crontab -e) that runs every monday at 22:00 hour: 
0 22 * * 1 cd /opt/m3u2strm && wget http://mywebsite.online/mym3u8file -O vod.m3u8 && ./m3u2strm.sh vod.m3u8 /var/www/ftp/kodi 1
<br>
<br>
<br>
<b>INSTALL NEEDED PACKAGES</b><br>
1.  apt install php curl wget<br>
2.  install php modules:<br>
    apt install php-cgi php-cli php-curl php-json php-mbstring php-yaml php-xml php-zip php-memcache php-memcached<br>
3.  enable php modules:<br>
    phpenmod curl && phpenmod mbstring && phpenmod yaml && phpenmod xml && phpenmod zip && phpenmod ctype<br>
    phpenmod exif && phpenmod fileinfo && phpenmod ffi && phpenmod ftp && phpenmod gettext && phpenmod iconv<br>
    phpenmod pdo && phpenmod phar && phpenmod posix  && phpenmod shmop && phpenmod sockets && phpenmod sysvmsg<br>
    phpenmod sysvsem && phpenmod tokenizer && phpenmod readline  && phpenmod memcache && phpenmod memcached<br>
4.  reboot system<br>
<br>
<br>
![m3u2strm](https://erdesigns.eu/images/m3u2strm-linux-2.png)

This is a simple script written in Bash and PHP. You can edit it to your liking, you could even move the PHP part to the Bash script, or put everything in the PHP script and make it executable. If you need more functions, please send me a email and i will happily share more functions relating to IPTV, M3U and converting to STRM files.

These scripts are written by Ernst Reidinga, ERDesigns.eu
https://erdesigns.eu/app/freeware/view/10

If you like our work, please like us on facebook: https://fb.me/erdesigns.eu
Want to buy me a coffee? Send me a mail via the contact form on our website or send a message on FB and i will send my paypal address :)

<br>
<br>
<b>Buy me a cup of coffee!</b> 🙂👍 <br>
https://urlshrt.eu/buycupofcoffee
<br>
<br>
<img src="https://urlshrt.eu/donateqr"></img>
<br>
<br>
