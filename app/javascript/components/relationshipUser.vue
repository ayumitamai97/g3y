<template>
  <article class='user'>
    <figure class='media-left user__image'>
      <!-- TODO: implement avatar -->
      <img
        alt='avatar'
        src='https://pbs.twimg.com/profile_images/1127137125114056705/grUfEmX__400x400.jpg'
      >
    </figure>
    <div class='media-content user__name has-text-weight-bold'>
      {{ item.name }}
    </div>
  </article>
</template>

<script lang='ts'>
export default {
  props: {
    item: {
      type: Object,
      default: () => {},
    },
  },
}
</script>

<style lang='sass'>
.user {
  &__image {
    // TODO: allow users to upload avatar
    height: 50px;
    width: 50px;
  }
}
</style>
