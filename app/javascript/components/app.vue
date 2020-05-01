<template>
  <div>
    <!-- ↓ TODO: ログアウト時のみ  -->
    <router-link to="/login">Login</router-link>
    <router-link to="/signup">Signup</router-link>
    <router-view></router-view>
  </div>
</template>

<script lang='ts'>
export default {
  name: 'app',
}
</script>
