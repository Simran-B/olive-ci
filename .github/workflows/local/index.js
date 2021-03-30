const core = require("@actions/core")

async function run() {
    try {
        const value = core.getInput("value")
        const obsolete = core.getInput("obsolete")
        core.info(`Input: value = ${value}`)
        core.info(`Input: obsolete = ${obsolete}`)
        core.setOutput("lower", value.toLowerCase())
        core.setOutput("upper", value.toUpperCase())
        core.setOutput("obsolete", "DO NOT USE ANYMORE!")
    } catch (error) {
        core.setFailed(error.message)
    }
}

run()
