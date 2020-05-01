<template>
  <div>
    <!-- ↓ TODO: ログアウト時のみ  -->
    <router-link to="/login">Login</router-link>
    <router-view></router-view>
  </div>
</template>

<script lang='ts'>
import Home from './home.vue'

export default {
  components: { Home },
}
</script>
