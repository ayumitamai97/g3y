<template>
  <div class="p-home">
    <h1 class="p-home__title">Home Timeline</h1>
    <div class="p-home__posts">
      <posts></posts>
    </div>
  </div>
</template>

<script lang='ts'>
import Posts from './posts'

export default {
  components: { Posts },
}
</script>
