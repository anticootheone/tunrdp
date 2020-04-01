## tunrdp.bat: SSH wrapper over old insecure RDP

#### Usage
Simply run this bat file from cmd or just by clicking on it, no administrative privelleges required.

It should work on Windows 10 and Windows 7.

#### Purpose
To wrap up and cover unsecure rdp session using ssh tunneling.

#### Use cases
* When ssh server installed on RDS server;
* When ssh server is in the same network as RDS server;
* When you need to access PC in the same network as the SSH server (RDP access should enabled on remote PC).

#### Author
Ilya Moiseev <ilya@moiseev.su>

#### Credits
This piece of code uses third-party tool: `plink.exe`

It can be found here: [https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)

License: [https://www.chiark.greenend.org.uk/~sgtatham/putty/licence.html](https://www.chiark.greenend.org.uk/~sgtatham/putty/licence.html)

#### Settings
Make sure to set all the values in correct manner in the script body, because **I didn't implement any setting values checks** :-)

For example:

**IP address of SSH server** to create a ssh tunnel using it:

`set tunip=10.0.10.100`

**PORT of the SSH server** to connect, default one is 22:

`set tunport=22`

**IP address of destination RDP server**:

`set dstrdpip=10.0.10.111`

**PORT of the RDP server**, default one is 3389:

`set dstrdpport=3389`

**PORT on localhost (127.0.0.1) interface** to connect on using RDP utility (mstsc.exe), you can leave 13777 as the default one:

`set localtunport=13777`

**USER with access to SSH server**, this needs to be configured on SSH server side separately, general recommendation is: create non-admin user with /usr/sbin/nologin as user's shell:

`set tunsshuser=tunnelrdpuser`

**PASSWORD for the SSH server user**, yes, in insecure manner. Do not generate password with special symbols, there will be an issue with batch handling it:

`set tunsshuserpwd=M3GaSEcR3tPAsSwOrD`

**SSH server fingerprint**, with this setting, plink.exe won't ask you to confirm and won't put this fingerprint into the registry. You can find it by issuing: `plink.exe -v -batch $HOSTNAME -P $PORT_NUMBER` The string after *"Host key finger print is:"* is our fingerprint to put here:

`set sshtunhostkey=18:c2:4d:3f:79:c2:c3:4a:76:14:44:83:8f:47:ae:ad`
