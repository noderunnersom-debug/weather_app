String friendlyErrorMessage(String rawMessage) {
  final message = rawMessage.toLowerCase();

  if (message.contains('location services are disabled')) {
    return 'Геолокация выключена. Включите её в настройках телефона, '
        'чтобы мы могли показать погоду в вашем городе.';
  }

  if (message.contains('permanently denied')) {
    return 'Доступ к геолокации запрещён навсегда. Разрешите его вручную '
        'в настройках приложения на телефоне.';
  }

  if (message.contains('location permissions are denied')) {
    return 'Нужен доступ к геолокации, чтобы показать погоду рядом с вами. '
        'Разрешите доступ и попробуйте снова.';
  }

  if (message.contains('timeout') ||
      message.contains('socketexception') ||
      message.contains('connection error') ||
      message.contains('failed host lookup') ||
      message.contains('network is unreachable')) {
    return 'Нет соединения с интернетом. Проверьте сеть и попробуйте снова.';
  }

  if (message.contains('401') || message.contains('403')) {
    return 'Сервис погоды временно недоступен. Попробуйте позже.';
  }

  return 'Не удалось загрузить данные о погоде. Попробуйте ещё раз.';
}