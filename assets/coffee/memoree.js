(function(){var t;t=function(){function t(t,e){this.opts=null!=e?e:{},this.opts=_.extend({shuffle:!0},this.opts),this.container=$(t),this.setup(),this.render()}return t.prototype.setup=function(){return this.uncovered_cards=0,this.matched_cards=0,this.card_zone=this.container.find(".card_zone"),this.load_deck(),this.setup_events()},t.prototype.setup_events=function(){return this.container.on("click",function(t){return function(e){var r,n,s,c;return s=!0,c=!0,n=$(e.target),r=$(e.currentTarget),n.is(".card")&&t.click_card(n,e),s&&e.preventDefault(),c?void 0:e.stopPropagation()}}(this))},t.prototype.load_deck=function(){return this.words=dictionary_words},t.prototype.render=function(){var t,e,r,n,s,c,o,i,d,a,u,h;for(this.cards=[],d=this.words,n=r=0,c=d.length;c>r;n=++r)u=d[n],h=u[0],i=u[1],t="<div class='card' data-id='"+n+"'><span>"+h+"</span></div>",this.cards.push(t),i="<div class='card' data-id='"+n+"m'><span>"+i+"</span></div>",this.cards.push(i);for(e=this.opts.shuffle?_.shuffle(this.cards):this.cards,a=[],s=0,o=e.length;o>s;s++)t=e[s],a.push(this.card_zone.append(t));return a},t.prototype.click_card=function(t,e){return this.check_cards_to?void 0:(this.uncovered_cards<2&&this.uncover(t),2===this.uncovered_cards?this.check_cards_to=setTimeout(function(t){return function(){return t.check_cards_to=null,t.check_uncovered_cards(),t.matched_cards===t.words.length?t.finished():void 0}}(this),500):void 0)},t.prototype.uncover=function(t){return t.addClass("uncover"),this.uncovered_cards++},t.prototype.check_uncovered_cards=function(){var t,e,r,n,s,c;return t=this.container.find(".card.uncover"),2!==t.length?console.log("not enough uncovered cards"):(n=function(){var n,s,c;for(c=[],n=0,s=t.length;s>n;n++)e=t[n],r=$(e).data("id"),c.push(r);return c}(),s=this.is_match(n[0],n[1]),c=s?(this.matched_cards++,"matched"):(setTimeout(function(t){return function(){return t.container.find(".miss").removeClass("miss")}}(this),800),"miss"),t.addClass(c).removeClass("uncover"),this.uncovered_cards=0,s)},t.prototype.is_match=function(t,e){return e===t+"m"||t===e+"m"},t.prototype.finished=function(){return console.log("all cards matched!"),this.container.addClass("complete")},t.prototype.reset=function(){return this.uncovered_cards=0,this.matched_cards=0,this.card_zone.html(""),this.container.removeClass("complete"),this.render()},t}(),$(function(){return document.memoree=new t("#memoree")})}).call(this);