const IPHUB_TOKEN = GetConvar("iphub_token", "");
if (IPHUB_TOKEN === '') {
    console.error('IPHUB_TOKEN convar not set! VPN check will not work!');
}

const iphub = require('./server/iphub')(IPHUB_TOKEN);


const isVPNExempt = async (steamid) => {
    return new Promise((res) => {
        setImmediate(() => {
            global.exports['mysql-async']['mysql_fetch_scalar']("SELECT COUNT(*) FROM vpn_exemptions WHERE steamid=@steamid", {
                '@steamid': steamid
            }, (result) => {
                res(result !== 0);
            });
        });
    });
};

// console.log(fetch);
on('playerConnecting', (name, setKickReason, deferrals) => {
    const player = global.source;
    if (IPHUB_TOKEN === '') return;

    deferrals.defer();

    setImmediate(() => {
        deferrals.update('Checking for VPN...');

        let ipAddress;
        let steamid;
        for (let i = 0; i < GetNumPlayerIdentifiers(player); i++) {
            const identifier = GetPlayerIdentifier(player, i);


            if (identifier.startsWith('steam:')) {
                steamid = identifier.substring(6);
            } else if (identifier.startsWith('ip:')) {
                ipAddress = identifier.substring(3);
            }

            if (ipAddress && steamid) break;
        }
        
        if (ipAddress === null) return deferrals.done('Could not check for VPN: IP not found.');
        
        (async () => {
            let data;
            try {
                data = await iphub.getIPInfo(ipAddress);
            } catch (e) {
                console.error(`error while checking if ip is vpn: ${e.toString()}`);
            }

            if (!data) {
                // Can't check right now - allow connection.
                return setImmediate(() => {
                    deferrals.done();
                });
            }

            const isBlock = data['block'] === 1;
            let isExempt = false;
            try {
                if (!steamid) throw new Error('No steamid to check exemption for.');

                isExempt = await isVPNExempt(steamid);
            } catch (ex) {
                console.error(`error while checking vpn exemptions: ${ex}`);
            }

            console.log(`${name} connecting from ${ipAddress} has isp ${data['isp']} w/ ASN ${data['asn']}. Decision: ${isBlock ? (isExempt ? 'exempt' : 'block') : 'allow'}`);

            // Jump back to game
            setImmediate(() => {

                // If blocked, deny connection
                if (isBlock && !isExempt) {
                    return deferrals.done('Please disable your VPN. If you think this is an error, join our Discord: https://discord.gg/roleplay');
                }

                // Otherwise, allow
                deferrals.done();
            });
        })()
    });
});

