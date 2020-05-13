<template>
  <div class='notification is-danger' v-if='errors.length > 0'>
    <button class='delete m-10' @click='closeError'></button>
    <div v-for='error in errors' :key='error'>
      <p>{{ error }}</p>
    </div>
  </div>
</template>

<script lang='ts'>
import util from '../src/util.ts'

export default {
  props: {
    errors: {
      type: Array,
      default: () => [],
    },
  },
  created(): void {
    this.closeError = util.closeError.bind(this)
    this.closeWarning = util.closeWarning.bind(this)
  },
}
</script>
