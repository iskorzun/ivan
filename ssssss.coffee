baseImageURL = 'images/'

init = ->

  ###*
  # Класс кнопки определения местоположения пользователя.
  # с помощью Geolocation API.
  # @see http://www.w3.org/TR/geolocation-API/
  # @class
  # @name GeolocationButton
  # @param {Object} params Данные для кнопки и параметры к Geolocation API.
  ###

  GeolocationButton = (params) ->
    GeolocationButton.superclass.constructor.call this, params
    # Расширяем опции по умолчанию теми, что передали в конструкторе.
    @geoLocationOptions = ymaps.util.extend({
      noCentering: false
      noPlacemark: false
      noAccuracy: false
      enableHighAccuracy: true
      timeout: 10000
      maximumAge: 1000
    }, params.options)
    return

  ###*
  # Класс хинта кнопки геолокации, будем использовать для отображения ошибок.
  # @class
  # @name GeolocationButtonHint
  # @param {GeolocationButton} btn Экземпляр класса кнопки.
  ###

  GeolocationButtonHint = (btn) ->
    map = btn.getMap()
    position = btn.options.get('position')
    @_map = map
    # Отодвинем от кнопки на 35px.
    @_position = [
      position.left + 35
      position.top
    ]
    return

  ymaps.util.augment GeolocationButton, ymaps.control.Button,
    onAddToMap: ->
      GeolocationButton.superclass.onAddToMap.apply this, arguments
      ymaps.option.presetStorage.add 'geolocation#icon',
        iconImageHref: 'man.png'
        iconImageSize: [
          27
          26
        ]
        iconImageOffset: [
          -10
          -24
        ]
      @hint = new GeolocationButtonHint(this)
      # Обрабатываем клик на кнопке.
      @events.add 'click', @onGeolocationButtonClick, this
      return
    onRemoveFromMap: ->
      @events.remove 'click', @onGeolocationButtonClick, this
      @hint = null
      ymaps.option.presetStorage.remove 'geolocation#icon'
      GeolocationButton.superclass.onRemoveFromMap.apply this, arguments
      return
    onGeolocationButtonClick: (e) ->
      # Меняем иконку кнопки на прелоадер.
      @toggleIconImage 'loader.gif'
      # Делаем кнопку ненажатой
      if @isSelected()
        @deselect()
      if navigator.geolocation
        # Запрашиваем текущие координаты устройства.
        navigator.geolocation.getCurrentPosition ymaps.util.bind(@_onGeolocationSuccess, this), ymaps.util.bind(@_onGeolocationError, this), @geoLocationOptions
      else
        @handleGeolocationError 'Ваш броузер не поддерживает GeolocationAPI.'
      return
    _onGeolocationSuccess: (position) ->
      @handleGeolocationResult position
      # Меняем иконку кнопки обратно
      @toggleIconImage 'wifi.png'
      return
    _onGeolocationError: (error) ->
      @handleGeolocationError 'Точное местоположение определить не удалось.'
      # Меняем иконку кнопки обратно.
      @toggleIconImage 'wifi.png'
      if console
        console.warn 'GeolocationError: ' + GeolocationButton.ERRORS[error.code - 1]
      return
    handleGeolocationError: (err) ->
      @hint.show(err.toString()).hide 2000
      return
    toggleIconImage: (image) ->
      @data.set 'image', baseImageURL + image
      return
    handleGeolocationResult: (position) ->
      location = [
        position.coords.latitude
        position.coords.longitude
      ]
      accuracy = position.coords.accuracy
      map = @getMap()
      options = @geoLocationOptions
      placemark = @_placemark
      circle = @_circle
      # Смена центра карты (если нужно)
      if !options.noCentering
        map.setCenter location, 15
      # Установка метки по координатам местоположения (если нужно).
      if !options.noPlacemark
        # Удаляем старую метку.
        if placemark
          map.geoObjects.remove placemark
        @_placemark = placemark = new (ymaps.Placemark)(location, {}, preset: 'geolocation#icon')
        map.geoObjects.add placemark
        # Показываем адрес местоположения в хинте метки.
        @getLocationInfo placemark
      # Показываем точность определения местоположения (если нужно).
      if !options.noAccuracy
        # Удаляем старую точность.
        if circle
          map.geoObjects.remove circle
        @_circle = circle = new (ymaps.Circle)([
          location
          accuracy
        ], {}, opacity: 0.5)
        map.geoObjects.add circle
      return
    getLocationInfo: (point) ->
      ymaps.geocode(point.geometry.getCoordinates()).then (res) ->
        result = res.geoObjects.get(0)
        if result
          point.properties.set 'hintContent', result.properties.get('name')
        return
      return

  ###*
  # Человекопонятное описание кодов ошибок.
  # @static
  ###

  GeolocationButton.ERRORS = [
    'permission denied'
    'position unavailable'
    'timeout'
  ]

  ###*
  # Отображает хинт справа от кнопки.
  # @function
  # @name GeolocationButtonHint.show
  # @param {String} text
  # @returns {GeolocationButtonHint}
  ###

  GeolocationButtonHint::show = (text) ->
    map = @_map
    globalPixels = map.converter.pageToGlobal(@_position)
    position = map.options.get('projection').fromGlobalPixels(globalPixels, map.getZoom())
    @_hint = map.hint.show(position, text)
    this

  ###*
  # Прячет хинт с нужной задержкой.
  # @function
  # @name GeolocationButtonHint.hide
  # @param {Number} timeout Задержка в миллисекундах.
  # @returns {GeolocationButtonHint}
  ###

  GeolocationButtonHint::hide = (timeout) ->
    hint = @_hint
    if hint
      setTimeout (->
        hint.hide()
        return
      ), timeout
    this

  myMap = new (ymaps.Map)('map',
    center: [
      55.755768
      37.617671
    ]
    zoom: 10
    behaviors: [
      'default'
      'scrollZoom'
    ])
  myButton = new GeolocationButton(
    data:
      image: baseImageURL + 'wifi.png'
      title: 'Определить местоположение'
    options: enableHighAccuracy: true)
  myMap.controls.add myButton,
    top: 5
    left: 5
  return

ymaps.ready init

# ---
# generated by js2coffee 2.1.0