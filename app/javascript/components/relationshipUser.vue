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
    <follow-button :following-id='item.id' />
  </article>
</template>

<script lang='ts'>
import FollowButton from './followButton.vue'

export default {
  components: { FollowButton },
  props: {
    item: {
      type: Object,
      default: () => ({ id: '', name: '' }),
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
