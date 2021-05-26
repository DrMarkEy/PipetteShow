<template>
  <div id="show-plate">
    <plate-holder :physical-plate-properties="plateProperties" :instruction-type="this.highlightedWell">
      <regular-grid-plate
        :cols="plateProperties.cols"
        :rows="plateProperties.rows"
        v-slot="slotProps"
        :margin-left="margins.left"
        :margin-top="margins.top"
      >
        <circular-labeled-well
          :class="getWellClasses(slotProps.wellId)"
          :radius="wellRadius"
        />
      </regular-grid-plate>
    </plate-holder>
  </div>
</template>

<script>
import PlateHolder from "./PlateHolder.vue";
import RegularGridPlate from "../common/RegularGridPlate.vue";
import CircularLabeledWell from "../common/CircularLabeledWell.vue";

export default {
  name: "show-plate",
  components: { PlateHolder, RegularGridPlate, CircularLabeledWell },

  props: ["highlighted-well"],

  computed: {
    plateProperties: function () {
      return this.$store.state.show.plate.dimensions;
    },

    wellRadius: function () {
      return (
        (this.plateProperties.radius /
          (this.plateProperties.width - 2 * this.plateProperties.marginLeft)) *
        this.plateProperties.cols *
        100
      );
    },

    margins: function () {
      return {
        top:
          (this.plateProperties.marginTop / this.plateProperties.width) * 100,
        left:
          (this.plateProperties.marginLeft / this.plateProperties.width) * 100,
      };
    },
  },

  methods: {
    getWellClasses: function (wellId) {
      var classes = [];

      if (this.highlightedWell === wellId) classes.push("highlighted");

      return classes;
    },
  },
};
</script>

<style></style>
