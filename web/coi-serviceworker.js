/*! coi-serviceworker v0.1.7 - Guido Zuidhof and contributors, licensed under MIT */
let coi = {
    shouldRegister: () => true,
    shouldDeregister: () => false,
    coepCredentialless: () => true,
    doCoep: () => true,
    quiet: false,
    check: () => window.crossOriginIsolated,
    window: self
};

if (typeof window === "undefined") {
    self.addEventListener("install", () => self.skipWaiting());
    self.addEventListener("activate", (event) => event.waitUntil(self.clients.claim()));

    self.addEventListener("fetch", (event) => {
        const request = event.request;
        if (request.cache === "only-if-cached" && request.mode !== "same-origin") return;

        event.respondWith(
            fetch(request)
                .then((response) => {
                    if (response.status === 0) {
                        return response;
                    }

                    const newHeaders = new Headers(response.headers);
                    newHeaders.set("Cross-Origin-Embedder-Policy", "require-corp");
                    newHeaders.set("Cross-Origin-Opener-Policy", "same-origin");

                    return new Response(response.body, {
                        status: response.status,
                        statusText: response.statusText,
                        headers: newHeaders,
                    });
                })
                .catch((e) => console.error("COI Service Worker fetch error:", e))
        );
    });
} else {
    (() => {
        const script = document.currentScript;
        const reloadedBySelf = window.sessionStorage.getItem("coiReloadedBySelf");
        window.sessionStorage.removeItem("coiReloadedBySelf");

        const coi = {
            shouldRegister: () => !reloadedBySelf,
            shouldDeregister: () => false,
            doCoep: () => true,
            quiet: false,
            ...window.coi,
        };

        if ("serviceWorker" in navigator) {
            navigator.serviceWorker.getRegistration().then((registration) => {
                if (registration && coi.shouldDeregister()) {
                    registration.unregister().then(() => {
                        window.location.reload();
                    });
                } else if (coi.shouldRegister() && !window.crossOriginIsolated) {
                    navigator.serviceWorker
                        .register(script ? script.src : "coi-serviceworker.js")
                        .then(
                            (reg) => {
                                !coi.quiet && console.log("COI Service Worker registered:", reg.scope);
                                reg.addEventListener("updatefound", () => {
                                    !coi.quiet && console.log("Reloading page to enable COI headers");
                                    window.sessionStorage.setItem("coiReloadedBySelf", "true");
                                    window.location.reload();
                                });
                                if (reg.active && !navigator.serviceWorker.controller) {
                                    !coi.quiet && console.log("Reloading page to enable COI controller");
                                    window.sessionStorage.setItem("coiReloadedBySelf", "true");
                                    window.location.reload();
                                }
                            },
                            (err) => {
                                !coi.quiet && console.error("COI Service Worker failed to register:", err);
                            }
                        );
                }
            });
        }
    })();
}
