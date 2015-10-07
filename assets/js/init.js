requirejs.config({
  baseUrl: 'assets/js/',
  paths: {
    jquery: 'cdn/jquery/jquery-2.1.4.min',
    jqModile: 'cdn/jquery/jquery.mobile.custom.min'
  }
});

require(['jquery', 'jqModile'], function($) {
  return $(document).ready(function() {
    var bindForm, insertForm;
    $('.left-menu ul>li').removeClass('active');
    $(".left-menu ul a[href='" + location.pathname + "']").parent().addClass('active');
    $('.mobile-menu').on('click touchend', function(e) {
      return $('.left-menu').toggleClass('openMenu');
    });
    (function() {
      var insetForm;
      window.bingFormIncub = function(startUpForm, base) {
        var subBtn;
        subBtn = startUpForm.children('.axs-submit');
        startUpForm.find('input').on('invalid', function(e) {
          return startUpForm.addClass('check');
        });
        startUpForm.on('submit', function(e) {
          var text, textanim;
          e.preventDefault();
          if (startUpForm.hasClass('done')) {
            subBtn.text('отправить');
            startUpForm.removeClass('done').removeClass('check').find('input').val('');
            return;
          }
          text = "Отправка";
          subBtn.prop('disabled', true).text(text);
          textanim = setInterval(function() {
            if (text.indexOf('...') === -1) {
              text += ".";
            } else {
              text = text.slice(0, -2);
            }
            subBtn.text(text);
          }, 500);
          return $.ajax({
            type: startUpForm.attr('method') || "post",
            url: startUpForm.attr('action') || '#',
            data: startUpForm.serialize(),
            success: function(msg) {
              clearInterval(textanim);
              startUpForm.addClass('done');
              return subBtn.text('отправить еще одну').prop('disabled', false);
            },
            error: function(msg) {
              console.log(arguments);
              clearInterval(textanim);
              return subBtn.text('Ошибка').prop('disabled', false);
            }
          });
        });
        if (base) {
          return setTimeout(function() {
            return base.addClass('open');
          }, 60);
        }
      };
      insetForm = function(base, findForm, nameInput, valueInput) {
        var form;
        form = base.find(findForm);
        if (form.length) {
          return bingFormIncub(form.find('form'), base);
        } else {
          form = $('.virtual').find(findForm).clone();
          $("<input type='hidden' name='" + nameInput + "' value='" + valueInput + "'>").appendTo(form.find('form'));
          base.append(form);
          return bingFormIncub(form.find('form'), base);
        }
      };
      return $('.incub-el').on('click touchend', '.incub-exe', function(e) {
        var $this, SRV;
        $this = $(this);
        SRV = $this.parents('article');
        if (SRV && SRV.length !== 0) {
          if (SRV.hasClass('open')) {
            SRV.removeClass('open');
            return $this.text('записаться на бета-тестирование');
          } else {
            insetForm(SRV, '.incub-form', 'test', SRV.children('h2').text());
            return $this.text('не подписываться');
          }
        }
      });
    })();
    bindForm = function(form, base) {
      var resetBtn, subBtn;
      subBtn = form.children('.curs-form-submit');
      resetBtn = form.children('.curs-form-hide');
      form.on('click touchend', '.curs-form-hide', function(e) {
        e.preventDefault();
        if (form.hasClass('done')) {
          resetBtn.text('не подписываться');
          form.removeClass('done').attr('style', '');
          subBtn.text('подписаться');
          return form.find('input').val('');
        } else {
          return form.removeClass('open');
        }
      });
      setTimeout(function() {
        return form.addClass('open');
      }, 60);
      return form.on('submit', function(e) {
        var text, textanim;
        e.preventDefault();
        if (form.hasClass('done')) {
          form.removeClass('open');
          subBtn.text('подписаться');
          return form.find('input').val('');
        } else {
          text = "Отправка";
          subBtn.prop('disabled', true).text(text);
          textanim = setInterval(function() {
            if (text.indexOf('...') === -1) {
              text += ".";
            } else {
              text = text.slice(0, -3);
            }
            subBtn.text(text);
          }, 500);
          return $.ajax({
            type: form.attr('method') || "post",
            url: form.attr('action') || '#',
            data: form.serialize(),
            success: function(msg) {
              var h2, intt;
              clearInterval(textanim);
              h2 = base.find('h2');
              intt = 500 - h2.position().top - h2.height();
              form.css({
                'height': intt + 'px',
                'bottom': -intt + 'px'
              });
              form.addClass('done');
              subBtn.text('хорошо, спасибо').prop('disabled', false);
              return resetBtn.text('подписаться еще раз');
            },
            error: function(msg) {
              console.log(arguments);
              clearInterval(textanim);
              return subBtn.text('Ошибка').prop('disabled', false);
            }
          });
        }
      });
    };
    insertForm = function(base) {
      var form;
      form = base.find('.clone-form');
      if (form.length) {
        return bindForm(form, base);
      } else {
        form = $('.clone-form').clone().removeClass('clone-form').attr('style', '');
        form.append("<input type='hidden' name='curs' value='" + (base.children('h2').text()) + "'>");
        base.append(form);
        return bindForm(form, base);
      }
    };
    $('.plan').on('click touchend', '.curs-showform', function(e) {
      e.preventDefault();
      return insertForm($(this).parents('.plan'));
    });
    return (function() {
      var frmAxler;
      frmAxler = $('.axs-body .axs-form');
      if (frmAxler && frmAxler.lenght !== 0) {
        return bingFormIncub(frmAxler);
      }
    })();
  });
});
