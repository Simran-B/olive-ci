const { test, expect } = require("@jest/globals")
const process = require("process")
const cp = require("child_process")
const path = require("path")

test("valid string", () => {
    process.env["INPUT_VALUE"] = "Hello World!"
    const ip = path.join(__dirname, "index.js")
    console.log(cp.execSync(`node ${ip}`, {env: process.env}).toString())
})

test("obsolete input", () => {
    process.env["INPUT_OBSOLETE"] = "Big oof."
    const ip = path.join(__dirname, "index.js")
    console.log(cp.execSync(`node ${ip}`, {env: process.env}).toString())
})
