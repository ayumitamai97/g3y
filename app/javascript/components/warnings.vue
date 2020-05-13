<template>
  <div class='notification is-warning' v-if='warnings.length > 0'>
    <button class='delete' @click='closeWarning'></button>
    <div v-for='warning in warnings' :key='warning'>
      <p>{{ warning }}</p>
    </div>
  </div>
</template>

<script lang='ts'>
import util from '../src/util.ts'

export default {
  props: {
    warnings: {
      type: Array,
      default: () => [],
    },
  },
  created(): void {
    this.closeWarning = util.closeWarning.bind(this)
  },
}
</script>
