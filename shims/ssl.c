/* SSLv3_{client,server}_method for Nougat-era MediaTek blobs.
 *
 * mtk_agpsd and libcurl-ss import them, but BoringSSL dropped SSLv3. Both map
 * to the version-flexible TLS methods, which every current SUPL/AGPS server
 * negotiates anyway.
 */
#include <openssl/ssl.h>

const SSL_METHOD *SSLv3_client_method(void) { return TLS_client_method(); }
const SSL_METHOD *SSLv3_server_method(void) { return TLS_server_method(); }
