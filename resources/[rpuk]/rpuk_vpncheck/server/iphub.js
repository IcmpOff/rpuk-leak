/**
 * Author: Jaffa
 * Major edits: Ciaran
 * https://github.com/DeliciousJaffa
 */
const axios = require("axios").default;
const iputil = require("ip6addr");

// console.log(Object.entries(exports['mysql-async']));

module.exports = (iphubToken) => {
    // Strip [] from IPv6 addresses
    const cleanIP = (ipStr) => {
        if (ipStr.charAt(0) === '[') {ipStr = ipStr.substr(1,ipStr.length-2)}
        return ipStr;
    }
    
    const getCached = async (ip) => {
        return new Promise((res) => {
            setImmediate(() => {
                    global.exports['mysql-async']['mysql_fetch_all']("SELECT ip, data FROM ipcache WHERE ip = @ip", {
                    '@ip': ip
                }, (result) => {
                    // Not cached
                    if (result.length === 0) return res(null);
                
                    let data;
                    try {
                        data = JSON.parse(result[0].data);
                    } catch (e) {
                        return res(null);
                    }

                    res(data);
                });
            });
        });
    }
    
    const setCache = async (ip, data) => {
        return new Promise((res) => {
            setImmediate(() => {
                global.exports['mysql-async']['mysql_execute']("INSERT IGNORE INTO ipcache (ip, data) VALUES (@ip, @data)", {
                    '@ip': ip,
                    '@data': JSON.stringify(data)
                }, () => res());
            });
        });
    }
    
    const getFromAPI = async (ip) => {
        const res = await axios.get(`http://v2.api.iphub.info/ip/${ip}`, {
            headers: {
                "X-Key": iphubToken,
                "Content-Type": "application/json"
            }
        });
    
        return res.data;
    }
    
    const getIPInfo = async (ipStr) => {
        // Convert IPv6 address to smallest possible allocation (/64)
        let ip = iputil.parse(cleanIP(ipStr));
        if (ip.kind() === "ipv6") {
            ip = iputil.createCIDR(ip, 64).address()
        }
    
        ip = ip.toString();
    
        const cached = await getCached(ip);
        if (cached) {
            return cached;
        }
    
        const data = await getFromAPI(ip);
        await setCache(ip, data);
    
        return data;
    };
    
    return {
        getIPInfo
    };
}
