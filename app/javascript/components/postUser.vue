<template>
  <article class='post-user level-left card'>
    <figure class='post-user__image'>
      <!-- TODO: implement avatar -->
      <img
        alt='avatar'
        src='https://pbs.twimg.com/profile_images/1127137125114056705/grUfEmX__400x400.jpg'
      >
    </figure>
    <div class='post-user__name has-text-weight-bold'>
      {{ item.name }}
    </div>
    <follow-button
      v-if='!isMyself'
      :following-id='item.id'
    />
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
  computed: {
    myUsername(): String {
      return this.$store.state.userName
    },
    isMyself(): Boolean {
      return this.item.name === this.myUsername
    },
  },
}
</script>

<style lang='sass'>
.post-user {
  position: absolute;
  border-radius: 15px;
  margin-top: 30px;
  margin-left: -250px;
  padding: 20px;

  &__image {
    height: 50px;
    width: 50px;
  }

  &__name {
    width: 150px;
    margin-left: 20px;
  }
}
</style>
