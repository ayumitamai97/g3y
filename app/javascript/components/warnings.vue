<template>
  <div
    v-if='warnings.length > 0'
    class='notification is-warning'
  >
    <button
      class='delete'
      @click='closeNotification'
    />
    <div
      v-for='warning in warnings'
      :key='warning'
    >
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
      default: (): string[] => [],
    },
  },
  data(): object {
    return {
      notifications: this.warnings,
    }
  },
  created(): void {
    this.closeNotification = util.closeNotification.bind(this)
  },
}
</script>
