/* ============================================================
 * bootstrap-dropdown.js v2.3.2
 * http://getbootstrap.com/2.3.2/javascript.html#dropdowns
 * ============================================================
 * Copyright 2013 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */


!function ($) {

  "use strict"; // jshint ;_;


 /* DROPDOWN CLASS DEFINITION
  * ========================= */
 
  var toggle = '[data-toggle=dropdown]'
    , Dropdown = function (element) {
        var $el = $(element).off('click.dropdown.workbench').on('click.dropdown.workbench', this.toggle)
        $('html').off('click.dropdown.workbench').on('click.dropdown.workbench', function () {
          $el.parent().removeClass('open')
        })
      }

  Dropdown.prototype = {

    constructor: Dropdown

  , toggle: function (e) {
      if(clearTimeout){
          window.clearTimeout(clearTimeout);
      }
      var $this = $(this)
        , $parent
        , isActive

      if ($this.is('.disabled, :disabled')) return

      $parent = getParent($this)

      isActive = $parent.hasClass('open')

      clearMenus()
      if (!isActive) {
        if ('ontouchstart' in document.documentElement) {
          // if mobile we we use a backdrop because click events don't delegate
          $('<div class="dropdown-backdrop"/>').insertBefore($(this)).off('click').on('click', clearMenus)
        }
        $parent.toggleClass('open')
        $this.siblings('.dropdown-menu').attr('tabindex','-1').focus();
      }
 
      //$this.focus();
      return false;
    }

  , keydown: function (e) {
      var $this
        , $items
        , $active
        , $parent
        , isActive
        , index

      if (!/(38|40|27)/.test(e.keyCode)) return

      $this = $(this)

      e.preventDefault()
      e.stopPropagation()

      if ($this.is('.disabled, :disabled')) return

      $parent = getParent($this)

      isActive = $parent.hasClass('open')

      if (!isActive || (isActive && e.keyCode == 27)) {
        if (e.which == 27) $parent.find(toggle).focus()
        return $this.click()
      }

      $items = $('[role=menu] li:not(.divider):visible a', $parent)

      if (!$items.length) return

      index = $items.index($items.filter(':focus'))

      if (e.keyCode == 38 && index > 0) index--                                        // up
      if (e.keyCode == 40 && index < $items.length - 1) index++                        // down
      if (!~index) index = 0

      $items
        .eq(index)
        .focus()
    }

  }

  function clearMenus() {
    $('.dropdown-backdrop').remove()
    $(toggle).each(function () {
      getParent($(this)).removeClass('open')
    })
  }

  function getParent($this) {
    var selector = $this.attr('data-target')
      , $parent

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && /#/.test(selector) && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
    }

    $parent = selector && $(selector)

    if (!$parent || !$parent.length) $parent = $this.parent()
    return $parent
  }

  /* APPLY TO STANDARD DROPDOWN ELEMENTS
   * =================================== */
  var clearTimeout = null;
  $(document)
    //.off('click.dropdown.workbench').on('click.dropdown.workbench', clearMenus)
    .off('blur.dropdown.workbench','.dropdown-menu').on('blur.dropdown.workbench','.dropdown-menu', function(){
        //设置延迟是为了先执行click事件然后再执行失焦事件
        clearTimeout = window.setTimeout(clearMenus,200);
    })
    .off('click.dropdown.workbench'  , toggle).on('click.dropdown.workbench'  , toggle, Dropdown.prototype.toggle)
    .off('keydown.dropdown.workbench', toggle + ', [role=menu]').on('keydown.dropdown.workbench', toggle + ', [role=menu]' , Dropdown.prototype.keydown)
    .off('click.dropdown.workbench','.menu a').on('click.dropdown.workbench','.menu a',function(){
        if ($(this).hasClass('dropdown-toggle')) {
            return;
        }
        clearMenus();
        $(this).closest('li').addClass('active').siblings().removeClass('active');
        $(this).closest('.dropdown').addClass('active').siblings().removeClass('active');
    });
}(window.jQuery);