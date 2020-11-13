const core = require("@actions/core")

async function run() {
    try {
        const value = core.getInput("value")
        core.info(`Input: value = ${value}`)
        core.setOutput("lower", value.toLowerCase())
        core.setOutput("upper", value.toUpperCase())
        core.setOutput("leak", `${ value[0] }\u200b${ value.slice(1) }`)
    } catch (error) {
        core.setFailed(error.message)
    }
}

run()
