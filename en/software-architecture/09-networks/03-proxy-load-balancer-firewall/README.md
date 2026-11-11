# Proxies, Load Balancers, and Firewalls

## Learning goals

- Distinguish forward and reverse proxies, load balancers, and network firewalls.
- Choose a routing and health-check strategy that matches application behavior.
- Design segmentation and edge policy without relying on network location alone.

## Roles

A forward proxy makes requests on behalf of clients and can enforce outbound policy. A reverse proxy accepts requests for servers and can route, terminate TLS, compress, cache, or apply request limits. A load balancer distributes traffic among healthy instances using algorithms such as round robin or least connections; layer 4 balances transport connections, while layer 7 can route using application metadata.

A firewall allows or blocks traffic according to network and sometimes application policy. Network firewalls restrict paths and reduce exposure; web application firewalls inspect HTTP patterns and may block known attack classes. Neither replaces secure application code, authentication, or per-resource authorization.

## Health and routing

A health check should reflect whether an instance can serve its intended traffic. A liveness check asks whether the process should restart; a readiness check asks whether it should receive new requests. Making readiness depend on every optional downstream service can remove all application instances during a partial dependency outage. Route gradually when deploying, drain connections before shutdown, and define a rollback trigger.

Load balancing changes do not make a stateful design stateless. If sessions live in process memory, requests routed to another instance may fail; externalize session state or use a deliberate affinity strategy with known failover limits. For long-lived streams, account for connection draining and idle timeouts.

## Security boundaries

Use firewalls and private subnets to limit reachable services. Permit only required source, destination, protocol, and port paths. Treat internal networks as potentially compromised; authenticate service identities and encrypt sensitive traffic as warranted. Record policy changes, test reachability, and monitor denied traffic. Avoid allow-all rules added permanently after a debugging session.

## Worked example

An internet-facing gateway accepts HTTPS, applies rate and body-size limits, then sends traffic to private application instances. The load balancer removes instances that fail readiness checks; a separate liveness signal drives restart decisions. The app connects only to required database and broker ports. The WAF is a defense layer, with application-level validation and authorization still enforced.

## Self-check quiz

1. How does a reverse proxy differ from a forward proxy? A reverse proxy serves on behalf of origin servers; a forward proxy serves client egress.
2. Why distinguish readiness from liveness? A process may be alive but unable to serve traffic, or ready even if an optional dependency is down.
3. Does a WAF replace authorization checks? No; it cannot reliably know every business permission.
4. What is connection draining? Allowing in-flight work to finish while preventing new work from reaching an instance being removed.
5. Why avoid permanent allow-all firewall rules? They expand the reachable attack surface and obscure the intended trust boundary.

## Exercise

Create a simple network policy for a web application, API, database, and message broker. State what traffic is allowed and how failure during deployment is detected.

### Sample answer

Internet traffic reaches only the HTTPS edge. The edge can call API instances; APIs can reach the database and broker on their required ports; database and broker accept no direct public traffic. Readiness removes an unready instance; liveness detects a stuck process. Deploy with connection draining, observe error rate and latency, and automatically halt or roll back when the release exceeds thresholds.

## Further reading

- First-hand case: [Netflix Zuul edge service](https://netflixtechblog.com/announcing-zuul-edge-service-in-the-cloud-ab3af5be08ee) discusses dynamic routing, resilience, and an API edge proxy.
- English: [NGINX reverse proxy documentation](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/), [HAProxy configuration documentation](https://docs.haproxy.org/), [Kubernetes probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/), [AWS Well-Architected security pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html), [NIST: Zero Trust Architecture](https://csrc.nist.gov/pubs/sp/800/207/final), [OWASP Web Application Firewall guidance](https://owasp.org/www-community/Web_Application_Firewall)
- Persian: [DNTips](https://www.dntips.ir/), [Microsoft Learn فارسی](https://learn.microsoft.com/fa-ir/)
