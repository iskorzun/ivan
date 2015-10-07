

requirejs.config
	baseUrl: 'assets/js/'
	paths:
		jquery: 'cdn/jquery/jquery-2.1.4.min'
		jqModile: 'cdn/jquery/jquery.mobile.custom.min'

require [
	'jquery'
	'jqModile'
], ($) ->
	$(document).ready ->

		# Активный елемент для ссылок
		$('.left-menu ul>li').removeClass('active')
		$(".left-menu ul a[href='#{location.pathname}']").parent().addClass('active')

		# Левое меню
		$('.mobile-menu').on 'click touchend',(e)->
			$('.left-menu').toggleClass('openMenu')










		# Инкубатор и форма
		do->
			window.bingFormIncub = (startUpForm,base)->
				# startUpForm = frm.find('form')
				subBtn = startUpForm.children('.axs-submit')
				startUpForm.find('input').on 'invalid',(e)->
					startUpForm.addClass('check')
				startUpForm.on 'submit',(e)->
					e.preventDefault()
					# console.log startUpForm.hasClass('done')
					if startUpForm.hasClass('done')
						subBtn.text('отправить')
						startUpForm.removeClass('done').removeClass('check').find('input').val('')

						return


					text = "Отправка"
					subBtn.prop('disabled',true).text(text)
					textanim = setInterval ()->
						if text.indexOf('...') == -1
							text+="."
						else
							text= text[0..-3]
						subBtn.text(text)
						return
					,500

					$.ajax
						type: startUpForm.attr('method') or "post"
						url: startUpForm.attr('action') or '#'
						data: startUpForm.serialize()
						success: (msg)->
							clearInterval(textanim)
							startUpForm.addClass('done')
							subBtn.text('отправить еще одну').prop('disabled',false)
						error: (msg)->
							console.log arguments
							clearInterval(textanim)
							subBtn.text('Ошибка').prop('disabled',false)
				if base
					setTimeout ->
						base.addClass('open')
					,60
			insetForm = (base,findForm,nameInput,valueInput)->
				form = base.find(findForm)
				if form.length
					bingFormIncub(form.find('form'),base)
				else
					form = $('.virtual').find(findForm).clone()
					$("<input type='hidden' name='#{nameInput}' value='#{valueInput}'>").appendTo(form.find('form'))
					base.append(form)

					bingFormIncub(form.find('form'),base)
			$('.incub-el').on 'click touchend','.incub-exe',(e)->
				$this = $(@)
				SRV = $this.parents('article')
				if SRV and SRV.length != 0
					if SRV.hasClass('open')
						SRV.removeClass('open')
						$this.text('записаться на бета-тестирование')
					else
						insetForm(SRV,'.incub-form','test',SRV.children('h2').text())
						$this.text('не подписываться')




		bindForm = (form,base)->
			subBtn = form.children('.curs-form-submit')
			resetBtn = form.children('.curs-form-hide')
			form.on 'click touchend','.curs-form-hide',(e)->
				e.preventDefault()
				if form.hasClass('done')
					resetBtn.text('не подписываться')
					form.removeClass('done').attr('style','')
					subBtn.text('подписаться')
					form.find('input').val('')
				else
					form.removeClass('open')

			setTimeout ->
				form.addClass('open')
			,60


			form.on 'submit',(e)->
				e.preventDefault()
				if form.hasClass('done')
					form.removeClass('open')
					subBtn.text('подписаться')
					form.find('input').val('')
				else

					text = "Отправка"
					subBtn.prop('disabled',true).text(text)
					textanim = setInterval ()->
						if text.indexOf('...') == -1
							text+="."
						else
							text= text.slice(0,-3)
						subBtn.text(text)
						return
					,500

					$.ajax
						type: form.attr('method') or "post"
						url: form.attr('action') or '#'
						data: form.serialize()
						success: (msg)->
							clearInterval(textanim)
							h2= base.find('h2')
							intt = 500 - h2.position().top - h2.height()
							form.css
								'height': intt+'px'
								'bottom': -intt+'px'

							form.addClass('done')
							subBtn.text('хорошо, спасибо').prop('disabled',false)
							resetBtn.text('подписаться еще раз')
						error: (msg)->
							console.log arguments
							clearInterval(textanim)
							# form.addClass('done')
							subBtn.text('Ошибка').prop('disabled',false)


		insertForm = (base)->
			form = base.find('.clone-form')
			if form.length
				bindForm(form,base)
			else
				form = $('.clone-form').clone().removeClass('clone-form').attr('style','')
				form.append("<input type='hidden' name='curs' value='#{base.children('h2').text()}'>")
				base.append(form)
				bindForm(form,base)



		$('.plan').on 'click touchend','.curs-showform',(e)->
			e.preventDefault()
			insertForm($(@).parents('.plan'))

		# Акселератор
		do->
			frmAxler = $('.axs-body .axs-form')
			if frmAxler and frmAxler.lenght != 0
				bingFormIncub(frmAxler)
