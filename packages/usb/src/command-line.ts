import Yargs from 'yargs';

export const yargs = Yargs
    .showHelpOnFail(true)
    .option('help', {
        description: 'Display help message'
    })
    .option('log', {
        description: 'Set logging categories. --log=misc,usb. Default is "none"',
        type: 'string',
        default: 'none',
        choices: ['all', 'config', 'misc', 'none', 'usb']
    })
    .option('usb-non-blocking', {
        description: 'Use USB non blocking communication',
        type: 'boolean',
        default: false
    })
    .help('help')
    .version(false)
;
