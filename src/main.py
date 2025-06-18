import configparser

config = configparser.ConfigParser()
config.read('config/settings.ini')

username = config['Settings']['username']
loglevel = config['Settings']['loglevel']

print(f"Username: {username}")
print(f"Loglevel: {loglevel}")
