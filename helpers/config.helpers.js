import { Configurator } from '@cityssm/configurator';
import { secondsToMillis } from '@cityssm/to-millis';
import config from '../data/config.js';
import { configDefaultValues } from './config.defaults.js';

const loginUsername = process.env.LOGIN_USERNAME;
const loginPassword = process.env.LOGIN_PASSWORD;

if (loginUsername && loginPassword) {
  config.login = {
    authentication: {
      config: {
        authenticate: (userName, password) => {
          const cleanUserName = userName.replace(/^\\/, '');
          return cleanUserName === loginUsername && password === loginPassword;
        }
      },
      type: 'function'
    },
    domain: ''
  };
  config.users = {
    canLogin: [loginUsername],
    canUpdate: [loginUsername],
    isAdmin: [loginUsername],
    testing: []
  };
}

const configurator = new Configurator(configDefaultValues, config);
export function getConfigProperty(propertyName, fallbackValue) {
    return configurator.getConfigProperty(propertyName, fallbackValue);
}
export default {
    getConfigProperty
};
export const keepAliveMillis = getConfigProperty('session.doKeepAlive')
    ? Math.max(getConfigProperty('session.maxAgeMillis') / 2, getConfigProperty('session.maxAgeMillis') - secondsToMillis(10))
    : 0;
