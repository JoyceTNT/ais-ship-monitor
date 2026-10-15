#!/usr/bin/env bash

cd ~
rm -rf myplaywright
mkdir myplaywright
cd myplaywright
npm init -y
npm install playwright@latest
npx playwright install chromium
echo '
const playwright = require("playwright-core");
const delay = ms => new Promise(resolve => setTimeout(resolve, ms))

async function main() {
  const browser = await playwright.chromium.launch({});
  const context = await browser.newContext({});
  const page = await context.newPage();
  page.on("console", (msg) => {
    console.log(msg.text());
  });

  page.on("load", () => console.log("page loaded"));
  await page.goto(
    "https://informatik.hs-bremerhaven.de/oradfelder/wezterm.html",
  );
  await delay(1000)

  await page.screenshot({ path: "playwright.png", fullPage: true });
  await browser.close();
}
main();
' > playwright-demo.js
time node playwright-demo.js
# on linux and macos only ...
convert playwright.png six:-; echo
