# React, Vue, and Angular

## Learning goals

- Compare the primary UI models and ecosystem trade-offs of React, Vue, and Angular.
- Structure front-end code around state, components, routing, and data boundaries.
- Choose a framework from team, product, accessibility, performance, and maintenance needs.

## Frameworks as architectural choices

React is a UI library centered on component composition and declarative rendering; application routing, data fetching, and build conventions are often supplied by a surrounding framework or chosen libraries. Vue offers a progressive framework with single-file components and a template/reactivity model. Angular is a more integrated framework with conventions for dependency injection, routing, forms, and TypeScript. All can build production systems; none eliminates the need for clear boundaries and state design.

Separate ephemeral UI state from server state and durable domain state. A selected tab is local UI state; a basket may need server persistence and authorization. Avoid duplicating one value across many components. Define loading, error, empty, stale, and success states. Keep business rules in a testable domain/service layer when they do not depend on rendering.

Components should own cohesive presentation and behavior with explicit inputs and outputs. Excessively small components increase indirection; huge components mix fetching, state, and rendering. Establish conventions for routing, error boundaries, validation, localization, accessibility, and test levels before the codebase becomes inconsistent.

## Performance and accessibility

Measure real user experience: loading, responsiveness, layout shifts, bundle size, and slow devices. Split code at meaningful route boundaries, avoid unnecessary renders, and virtualize very large lists only when measured. Framework choice does not guarantee accessibility: semantic HTML, keyboard access, focus management, labels, and screen-reader testing remain required.

## Worked example: checkout form

Treat the form as a state machine: address editing, validation, submitting, recoverable failure, and confirmation. Disable accidental duplicate submission while retaining server-side idempotency. Preserve safe user input on transient failure, never trust browser totals, and announce validation errors accessibly.

## Self-check quiz

1. What is the difference between a UI library and an integrated framework? The latter typically supplies more official conventions and modules; exact boundaries vary.
2. Why separate server state from local UI state? They have different ownership, freshness, persistence, and synchronization needs.
3. Does a component framework provide accessibility automatically? No; semantics, keyboard, focus, and testing still matter.
4. Why keep checkout totals authoritative on the server? The client is untrusted and values can be modified.
5. What should guide framework selection? Team familiarity, ecosystem, product needs, integration, maintainability, and measured performance.

## Exercise

Sketch checkout component boundaries and state transitions, including a network timeout after submission.

### Sample answer

Use address, delivery option, order summary, and payment sections coordinated by a checkout route/state controller. Model idle, validating, submitting, recoverable error, and confirmed states. Retain non-sensitive form state after a timeout, retry with the same idempotency key, and fetch authoritative order status before offering another charge.

## Further reading

- English: [React documentation](https://react.dev/learn), [Vue guide](https://vuejs.org/guide/introduction.html), [Angular documentation](https://angular.dev/overview), [MDN: Accessibility](https://developer.mozilla.org/en-US/docs/Web/Accessibility), [web.dev: Core Web Vitals](https://web.dev/articles/vitals), [W3C WAI tutorials](https://www.w3.org/WAI/tutorials/)
- Persian: [MDN Persian documentation](https://developer.mozilla.org/fa/), [Quera front-end learning paths](https://quera.org/college)
