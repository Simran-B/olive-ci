const core = require("@actions/core")

async function run() {
    try {
        const value = core.getInput("value")
        core.info(`Input: value = ${value}`)
        core.setOutput("lower", value.toLowerCase())
        core.setOutput("upper", value.toUpperCase())
    } catch (error) {
        core.setFailed(error.message)
    }
}

run()
