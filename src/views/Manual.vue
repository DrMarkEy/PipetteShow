<template>

  <page-layout class="manual">
        <header class="uk-text-center">
      <h1 class="uk-heading-primary serifs">
        Manual
      </h1>
    </header>

<div uk-grid>
<div id="offcanvasnav"  uk-offcanvas>
<div class="uk-offcanvas-bar">
 <ul ref="mobilenav" class="uk-nav uk-nav-default" uk-scrollspy-nav="closest: li; scroll: true">
<!-- li are autoinserted upon mount -->
    </ul>
            <button class="uk-offcanvas-close" type="button" uk-close></button>

        </div>
</div>
<aside id="manualnav" class="uk-width-1-4 uk-visible@m"> 
<div style="position: fixed;">
 <ul ref="nav" class="uk-nav uk-nav-default" uk-scrollspy-nav="closest: li; scroll: true">
<!-- li are autoinserted upon mount -->
    </ul>
</div>

</aside>
<div id="content" class="uk-width-expand">
<div class="uk-flex uk-flex-right">
<button class="uk-button uk-button-primary uk-hidden@m" uk-toggle="target: #offcanvasnav" type="button"><span uk-icon="icon: file-text"></span>
Open TOC
</button>
</div>

<h2 id="first">First Heading</h2>

asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>

<h2 id="second">Second Heading</h2>

asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
asdf<br>
</div></div>

  </page-layout>
</template>

<script>
import PageLayout from "../components/home/PageLayout.vue";

export default {
  name: "manual",
  components: { PageLayout },

   mounted: function() {
    const nav = this.$refs.nav
    const mobilenav = this.$refs.mobilenav
    const headings = document.querySelectorAll(`#content h2, #content h3`);

      headings.forEach(value => {
        
        if (value.tagName === 'H2') {
          
          
          const li = document.createElement('li');
          const a = document.createElement('a');
          a.innerHTML = value.textContent;
          a.href = `#${value.id}`;
    
          li.appendChild(a);
          
          mobilenav.appendChild(li.cloneNode(true));
          nav.appendChild(li);
          
        }
      
});


    },

};
</script>

<style lang="scss">
.manual {
}
</style>
