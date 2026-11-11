# Microfrontends, Mobile, and Web Standards

## Learning goals

- Understand microfrontend decomposition and its integration costs.
- Compare native, cross-platform, and responsive web delivery.
- Apply browser standards and accessibility practices as architectural constraints.

## Microfrontends

Microfrontends apply independently owned deployment or development boundaries to parts of a user interface. They can help large organizations coordinate teams around product domains, but add runtime integration, duplicate dependencies, inconsistent user experience, shared navigation, and cross-boundary testing. Start with clear module boundaries inside one deployable front end; split deployments when organizational independence or release needs justify the cost.

Choose an integration style deliberately: build-time composition, server-side composition, or runtime composition. Define ownership of design system, authentication, routing, error handling, telemetry, and shared state. Avoid a shared global state store that recreates tight coupling across supposedly independent teams.

## Mobile delivery

Native apps offer direct platform APIs and platform-specific user experience. Cross-platform frameworks share some code while retaining native integration and release considerations. Responsive web avoids app-store distribution and can reach users quickly, while offline support, background execution, push notifications, and device capabilities may be more constrained. Progressive Web Apps can bridge some gaps but capabilities vary by browser and operating system.

Plan for unstable networks, small screens, battery limits, app version skew, privacy permissions, and accessible touch targets. An old installed client may call the backend long after a new release, so APIs must remain compatible or provide a managed upgrade path.

## Standards and interoperability

HTML, CSS, JavaScript, HTTP, and accessibility standards create interoperable foundations. Prefer semantic elements and progressive enhancement where it improves resilience. Use feature detection rather than browser-name assumptions. Validate behavior with keyboard, screen readers, zoom, contrast, and automated checks; a passing automated scan alone is not proof of accessibility.

## Worked example

A retail organization with independent catalog and checkout teams can first ship both as modules within one application and agree on route, event, visual, and accessibility contracts. If separate releases become valuable, add isolated deployment with a shared design system and end-to-end contract tests. For mobile, use the same domain APIs but adapt offline and authentication behavior to the chosen platform.

## Self-check quiz

1. What organizational problem can microfrontends address? Independent teams need to own and release distinct UI domains.
2. Name two costs of runtime microfrontends. Dependency duplication and more complex integration/testing are two examples.
3. Does cross-platform mean zero platform-specific code? No; device APIs, lifecycle, and UX often require platform-specific work.
4. Why use semantic HTML? It conveys meaning to browsers and assistive technology and improves robust interaction.
5. How does client version skew affect API design? Older clients can continue using previous contracts and require compatibility.

## Exercise

Propose a front-end boundary for catalog and checkout. Decide when independent deployment is justified and define the contract and ownership needed.

### Sample answer

Initially keep domain modules in one deployable app with separate routing and state boundaries. Split deployments only when teams need independent release cadence and can own accessibility, telemetry, compatibility, and rollback. Define navigation, design tokens, event/API contracts, dependency policy, and cross-domain acceptance tests.

## Further reading

- English: [Martin Fowler: Micro Frontends](https://martinfowler.com/articles/micro-frontends.html), [W3C Web Standards](https://www.w3.org/standards/), [WHATWG HTML Living Standard](https://html.spec.whatwg.org/), [W3C Web Content Accessibility Guidelines](https://www.w3.org/WAI/standards-guidelines/wcag/), [MDN Progressive Web Apps](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps), [Android architecture guidance](https://developer.android.com/topic/architecture), [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- Persian: [MDN فارسی](https://developer.mozilla.org/fa/), [Quera front-end learning path](https://quera.org/college)
