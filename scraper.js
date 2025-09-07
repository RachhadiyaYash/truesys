import express from "express";
import { chromium } from "playwright";

const app = express();
const PORT = process.env.PORT || 3000;

app.get("/scrape", async (req, res) => {
  try {
    console.log("🚀 Launching browser...");

    const browser = await chromium.launch({
      headless:false,
      args: ["--no-sandbox", "--disable-gpu"]
    });

    const page = await browser.newPage();

    console.log("🌐 Navigating...");
    await page.goto("https://ipostatus.kfintech.com/", { waitUntil: "domcontentloaded" });

    // 🚨 For testing, skip clicking / waiting
    console.log("🔍 Fetching page title...");
    const title = await page.title();

    // Optionally dump entire body
    const bodyText = await page.evaluate(() => document.body.innerText);

    await browser.close();

    res.json({
      status: "success",
      title,
      preview: bodyText.slice(0, 500) // send first 500 chars
    });
  } catch (err) {
    console.error("❌ Scraper failed:", err);
    res.status(500).json({
      status: "error",
      message: err.message
    });
  }
});

app.get("/", (req, res) => {
  res.send("✅ IPO Scraper API is running. Use /scrape to fetch IPO list.");
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Server running on http://0.0.0.0:${PORT}`);
});
