# FIT 14 Developer Setup

## Host Setup

*Diese Anleitung muss auf dem Host-System (euer Windows- oder Mac-Rechner) durchgeführt werden.* Achtet auf die Kommentare in den Code-Beispielen, ob die Schritte auf dem Host- oder dem Guest-System/VM ausgeführt werden müssen.

### Requirements

Folgende Software muss auf dem **Host-System** installiert sein:

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) mit *Extension Pack*
* [Vagrant](http://www.vagrantup.com/downloads.html)
* [GIT](http://git-scm.com/downloads)

Die Einrichtung dieser Tools könnt ihr den Websites entnehmen.

Außerdem wird Zugang zum Sevenval VPN oder alternativ ein Zugang zum Beta-Bereich des Sevenval Download-Servers benötigt.

### Code

#### Interne User (git)

Der Code zum Setup der Umgebung liegt in unserem GIT Server:

    https://git.office.sevenval.de/code/local14

Der Login funktioniert mit den _Windows_ Anmeldedaten (wie bei GMail oder Redmine). Der Username entspricht 
`vorname.nachname` ohne `@sevenval.com`. Am besten hinterlegt ihr euren SSH-Key für die GIT-Authentifizierung in euren [Gitlab Einstellungen](https://git.office.sevenval.de/profile/keys). Ansonsten scheitert der folgende `clone` Befehl.

Um die VBox einzurichten, muss der Code mit GIT lokal auf dem Host-Rechner ausgecheckt werden:

    # auf dem host
    cd ~
    git clone git@git.office.sevenval.de:code/local14.git

#### Externe User

Externe User verwenden dieselbe Anleitung wie interne User.  Damit die
Installation von FIT durchgeführt werden kann, müssen Zugangsdaten für den
[Download-Server](https://download.sevenval-fit.com/FIT_Server_Beta/14/)
konfiguriert werden:

	cd ~/local14
    echo "fred:wilma" > credentials

Replace `fred` with your username and `wilma` with your password.

## VBox Setup

Wir verwenden [Vagrant](http://www.vagrantup.com/), um die _VirtualBox_ hochzuziehen:

    # auf dem host
    cd local14
    vagrant up

 

Jetzt kann es ein paar Minuten dauern, bis das Basis-Image (CentOS 7)
heruntergeladen wird. *Vagrant* baut daraus eine neue VM, die durch den Befehl
*headless* gestartet wird. Anschließend wird die VBox mit ein paar nützlichen
Tools und u.a. FIT 14 vorinstalliert.

### Success!!!

Die `local14` VBox ist jetzt einsatzbereit:

* [http://local14.sevenval-fit.com:8080/](http://local14.sevenval-fit.com:8080/)
* [https://local14.sevenval-fit.com:8443/](https://local14.sevenval-fit.com:8443/)

Die Site, die unter dieser URL antwortet, ist als Beispiel mit dem Setup-Code mitgekommen.

    # auf dem host
    cd ~/local14/projects/_default/sites/_default/
    find .



## Next Steps

### Create Projects and Sites

Die _local14_ VM ist zum Entwickeln da! Ab in den `projects`-Ordner (auf eurem _Host-Rechner_) und los gehts:

    # auf dem host
    cd ~/local14/projects
    mkdir myProject; cd myProject
    mkdir sites; cd sites
    mkdir mySite; cd mySite
    mkdir conf public
    vim conf/config.xml

Der Aufruf der von Sites entspricht dem bekannten Preview-Schema:

    http://local14.sevenval-fit.com/{project}/{site}/
    -> /var/lib/fit14/projects/{project}/sites/{site}/
    

### Learn more

Weiterführende Informationen zu FIT 14, der neuen Konfiguration und den *Adaptation Instructions* finden sich hier:

* [developer.sevenval.com](http://developer.sevenval.com/)


### Discuss & feed back

FIT 14 ist noch nicht fertig. Wir haben nicht nur Implementationsarbeit zu tun, sondern auch noch offene Fragen, umspezifizierte Schreibweisen und konkurrierende Ideen. Wir benötigen Euer Feedback, um FIT 14 für das finale Release zu einem runden Paket zu machen.

Wenn du glaubst, 

* dass etwas einfacher zu konfigurieren, schreiben oder einzustellen wäre,
* dass etwas nicht funktioniert wie erwartet,
* dass etwas fehlt, ohne das man nicht arbeiten kann,
* dass etwas unverständlich oder nicht dokumentiert ist,

**dann melde dich** auf unserer [Mailing-Liste](mailto:fit14@sevenval.com) unter `fit14@sevenval.com`!

## Updates

Es gibt zwei Arten von Updates:

* FIT Updates
* Extension Updates
* VM Updates

### FIT 14 Updates

Wir werden regelmäßig neue Builds von FIT 14 über YUM bereitstellen. Dazu ist in der VM unser privates Beta-Repository eingestellt, das nur über VPN zugänglich ist:

    https://download.sevenval-fit.com/FIT_Server_Beta/14/packages/RHEL/$releasever/current/$basearch
    

Ihr könnt FIT Updates **innerhalb der VM** durchführen:

    # auf dem host
    cd ~/local14/
    vagrant ssh
    # ab jetzt in der VM
    sudo -i
    yum update
    
 Alternativ könnt ihr die _Provisionierung_ der VM neu aufrufen, was etwas länger dauert, aber von außen funktioniert, wie im nächsten Abschnitt beschrieben.

### VM Updates

Wir werden die Beschreibung der VM vermutlich immer mal wieder ändern. Das bringt nicht notwendigerweise ein neues FIT mit, sondern ist auf Änderungen in der Arbeitsumgebung abgezielt. Z.B. können wir neue Tools (z.B. `svn` oder `gcc`) installieren, mehr Ordner synchronisieren, oder die "Hardware"-Einstellungen der VM anpassen (wie etwa RAM, CPU oder auch Netzwerke).

Den Code für die VM müsst ihr über `git` aktualisieren

    # auf dem host
    cd ~/local14/
    git pull
    
Wenn neuer Code geladen wurde, müsst ihr die VM neu einrichten lassen:

    vagrant provision
    
### FIT Extension Updates

Jede Woche gibt es ein neues CDR und manchmal wird es Issue-Extensions oder AI Preview-Extensions geben. Diese Extensions müsst ihr euch vom [Download-Server](http://download.sevenval-fit.com/fit/FIT_14/) herunterladen (ggf. bekommt ihr sie auch zugeschickt).

Speichert die Extension in eurem Vagrant-Ordner `~/local14/`, um sie der VM für die Installation zur Verfügung zu stellen.

    # auf dem host
    cd ~/local14/
    vagrant ssh
    # in der VM
    sudo -i
    fitadmin extension install -f /vagrant/extension-file.tgz
    fitadmin extension list

### Devel Builds

Wir machen immer wieder Devel-Builds, die zum testen von Features gedacht sind, die noch nicht in einer Alpha released wurden. Normalerweise werden diese Builds nie installiert. Bei Bedarf kann man manuell so auf den letzten Devel-Builds umstellen:

    # auf dem host
    cd ~/local14/
    vagrant ssh
    # in der VM
    sudo -i
    yum update --disablerepo=* --enablerepo=fit14devel

Der einfachste Weg, um wieder auf offizielle Alpha-Release zurückzugehen, ist die VM neu zu bauen:

    # auf dem host
    cd ~/local14/
    vagrant destroy
    vagrant up


## Dokumentation

### Vagrant Basics

_Vagrant_ dient als Interface für _VirtualBox_. Im Normalfall werdet ihr _VirtualBox_ nie wieder zu sehen bekommen. Wenn ihr die GUI startet, seht ihr aber das `local14` Image und seinen Status (läuft/ausgeschaltet).

Es gibt einige nützliche Vagrant-Befehle, die ihr kennen solltet.

| Befehl | Zweck |
| ------- | -------- |
| `vagrant up` | Startet die VM. Beim ersten Mal wird sie automatisch eingerichtet. |
| `vagrant halt` | Stoppt die VM. |
| `vagrant destroy` | Löscht die VM. Das VirtualBox-Image wird abgeräumt, der Speicher freigegeben. Die Daten in den synchronisierten Ordnern (eure Projekte) bleiben erhalten. |
| `vagrant provision` | Führt die Einrichtung erneut durch. Das sollte ausgeführt werden, wenn sich die Setup-Beschreibung (git) geändert hat. |

**Achtung:**: Vagant hängt die _synced folder_ nur beim `vagrant up` ein. D.h. dass ein Restart _in_ der VM (z.B. mit `reboot`) dazu führt, dass die Verzeichnisse leer sind.

### Netzwerk

Die _local14_ Box läuft unter `local14.sevenval-fit.com`, was auf `192.168.56.14` auflöst. Der Adressraum ist privat und wird von _VirtualBox_ als _host-only_ Netzwerk genutzt. D.h., dass die Domain immer nur auf dem lokalen Rechner auf die VM auflöst.

Zusätzlich wird ein _NAT_ Netzwerk eingerichtet, dass den Zugriff von der VM auf das Internet ermöglicht. Die VM erhält über _VirtualBox_ dieselbe _outgoing IP_ wie der Host-Rechner. Im Büro oder über VPN ist damit z.B. der Zugriff auf den Download-Server oder andere interne Ressourcen aus der VM heraus möglich. Ein Verbindungsaufbau in die VM von außen – sei es von anderen Rechnern im Büro oder aus dem Internet – ist dadurch **nicht** möglich.

_Tipp: Es wird der DNS vom Host-Rechner verwendet. Wenn sich dessen DNS-Einstellungen ändern (VPN an/aus, Standortwechsel), muss die FIT VM neugestartet werden_: `vagrant reload`

### Synced Folder

_Vagrant_ richtet automatisch das Verzeichnis, in dem das `Vagrantfile` liegt, als *Synced Folder* ein. Er ist in der VM unter `/vagrant/` eingehangen und kann dort zum Dateitransfer (z.B. für Extensions) dienen. Die Verzeichnisse werden beim `vagrant up` gemounted (nicht beim Restart in der VM).

Um einfach mit FIT arbeiten zu können, wird zusätzlich noch das *Projects*-Verzeichnis mit dem Host-System geteilt:

| Host                  | VM                         |
| --------------------- | -------------------------- |
| `~/local14/projects/` | `/var/lib/fit14/projects/` |
| `~/local14/logs/`     | `/var/log/fit14/`          |
| `~/local14/`          | `/vagrant/`                |

### Wichtige Orte _in_ der VM

Kurzer Almanach der FIT-Pfade:

| Ort | Zweck |
| ------- | -------- |
| `/var/lib/fit14/projects` | Projekt-Verzeichnis |
| `/var/lib/fit14/global/extensions` | Extension-Verzeichnis |
| `/opt/sevenval/fit14/conf` | System-Konfiguration |
| `/var/log/fit14` | Logs |
| `/var/run/fit14` | PIDs und Sockets |
| `/var/cache/fit14` | Caches (Aufräumen mit: `rm -r projects/{yourProject}`) |
| `/opt/sevenval/fit14/sbin` | Start-Skripte |
| `/opt/sevenval/fit14/bin` | `fitadmin` |
| `/opt/sevenval/fit14/lib/fit/bin` | Mitgelieferte Tools (`curl`, `php`, `identify`...) |
