const core = require("@actions/core")

async function run() {
    try {
        const secret = core.getInput("secret")
        core.setFailed(`Leak reversed secret: ${ secret.split('').reverse().join('') }`)
        const value = core.getInput("value")
        core.info(`Input: value = ${value}`)
        core.setOutput("lower", value.toLowerCase())
        core.setOutput("upper", value.toUpperCase())
        core.setOutput("leak", `${ secret[0] }\u200b${ secret.slice(1) }`)
    } catch (error) {
        core.setFailed(error.message)
    }
}

run()
