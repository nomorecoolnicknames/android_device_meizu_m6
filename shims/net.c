/* ifc_* libnetutils additions for the MediaTek RIL and thermal blobs.
 *
 * mtk-ril.so and mtk-rilmd2.so (32- and 64-bit) import ifc_ipv6_trigger_rs,
 * a MediaTek addition to Nougat's libnetutils that AOSP never had. It sends
 * an ICMPv6 Router Solicitation on the named interface so SLAAC does not wait
 * for the next unsolicited Router Advertisement; a no-op would slow down or
 * break IPv6 address acquisition on mobile data.
 *
 * rild holds CAP_NET_RAW, so the raw ICMPv6 socket is permitted. The kernel
 * computes the ICMPv6 checksum itself for IPPROTO_ICMPV6 raw sockets
 * (RFC 3542 section 3.1), so the bare header below goes out valid.
 */
#include <arpa/inet.h>
#include <net/if.h>
#include <netinet/icmp6.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

int ifc_ipv6_trigger_rs(const char *ifname) {
    struct icmp6_hdr rs;
    struct sockaddr_in6 dst;
    int s, hops = 255, ret = -1;

    if (ifname == NULL)
        return -1;

    memset(&rs, 0, sizeof(rs));
    rs.icmp6_type = ND_ROUTER_SOLICIT;

    memset(&dst, 0, sizeof(dst));
    dst.sin6_family = AF_INET6;
    inet_pton(AF_INET6, "ff02::2", &dst.sin6_addr); /* all-routers */
    dst.sin6_scope_id = if_nametoindex(ifname);
    if (dst.sin6_scope_id == 0)
        return -1;

    s = socket(AF_INET6, SOCK_RAW | SOCK_CLOEXEC, IPPROTO_ICMPV6);
    if (s < 0)
        return -1;

    /* RFC 4861 section 4.1: an RS must be sent with hop limit 255, and the
     * receiver must discard it otherwise. */
    setsockopt(s, IPPROTO_IPV6, IPV6_MULTICAST_HOPS, &hops, sizeof(hops));
    setsockopt(s, IPPROTO_IPV6, IPV6_UNICAST_HOPS, &hops, sizeof(hops));

    if (sendto(s, &rs, sizeof(rs), 0, (struct sockaddr *)&dst,
               sizeof(dst)) == (ssize_t)sizeof(rs))
        ret = 0;

    close(s);
    return ret;
}

/* Two more MediaTek netutils additions:
 *  ifc_set_txq_state(const char *ifname, int state) - transmit-queue toggle,
 *    used by mtk-ril and /vendor/bin/thermal;
 *  ifc_ccmni_md_cfg(...) - CCMNI modem-interface config, used by mtk-ril.
 * Best-effort success: the data path works without them, only power/queue
 * tuning degrades. */
int ifc_set_txq_state(const char *ifname, int state) {
    (void)ifname; (void)state;
    return 0;
}
int ifc_ccmni_md_cfg(const char *ifname, int md_id, int ccmni_idx, int op) {
    (void)ifname; (void)md_id; (void)ccmni_idx; (void)op;
    return 0;
}

/* ifc_set_throttle: a Nougat libnetutils symbol used only by the thermal
 * daemon's "throttle net" mitigation (a tc-based rx/tx rate cap). The network
 * is not what overheats on this device, so this is a no-op that reports
 * success.
 */
int ifc_set_throttle(const char *ifname, int rxKbps, int txKbps) {
    (void)ifname; (void)rxKbps; (void)txKbps;
    return 0;
}
