<script setup lang="ts">
import { RouterLink } from 'vue-router';

const props = defineProps({
  routerName: { type: String, required: true },
  termSearch: { type: String },
  totalItems: { type: Number, required: true },
  currentPage: { type: Number, default: 1 },
  perPage: { type: Number, default: 25 },
})

const totalPages = Math.ceil(props.totalItems / props.perPage);

const getPreviousPage = () => (props.currentPage > 1 ? props.currentPage - 1 : 0);

const getNextPage = () => (props.currentPage < totalPages ? props.currentPage + 1 : 0);


const generatePaginationLinks = (minimumPage: number = 5) => {
  const generatePageRange = (start: number, end: number) =>
    Array.from({ length: end - start + 1 }, (_, index) => start + index);

  if (totalPages < minimumPage) {
    return generatePageRange(1, totalPages);
  }

  const pagesBeforeCurrent = Math.floor(minimumPage / 2);
  const pagesAfterCurrent = minimumPage - 1 - pagesBeforeCurrent;

  if (props.currentPage <= pagesBeforeCurrent + 1) {
    const initialPages = generatePageRange(1, minimumPage - 1);
    return [...initialPages, '...', totalPages];
  }

  if (props.currentPage >= totalPages - pagesAfterCurrent) {
    const finalPages = generatePageRange(totalPages - minimumPage + 2, totalPages);
    return [1, '...', ...finalPages];
  }

  const navigationPages:any = [
    getPreviousPage(),
    props.currentPage,
    getNextPage()
  ];

  if (props.currentPage + pagesAfterCurrent < totalPages) {
    navigationPages.push('...', totalPages);
  }

  return navigationPages;
};

</script>

<template>
  <ul class="flex text-base h-10">
    <RouterLink
      v-if="getPreviousPage() > 0"
      :to="{ name: props.routerName, query: { page: getPreviousPage(), search: props.termSearch } }"
      class="flex items-center justify-center px-3 h-10 ms-0 leading-tight text-gray-500 bg-white rounded-s-lg hover:bg-violet-200 hover:text-violet-600"
    >
      Previous
    </RouterLink>

    <span v-else class="flex items-center justify-center px-3 h-10 ms-0 leading-tight text-gray-500 bg-white rounded-s-lg hover:bg-violet-200 hover:text-violet-600 disabled">Previous</span>

    <div class="flex flex-row" v-for="page in generatePaginationLinks()">
      <RouterLink
        v-if="page != '...'"
        :key="page"
        :to="{ name: props.routerName, query: { page: page, search: props.termSearch } }"
        :class="{'text-violet-600 bg-violet-200': currentPage === page}"
        class="flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white  hover:bg-violet-200 hover:text-violet-600"
      >
        {{ page }}
      </RouterLink>

      <span v-else class="flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white">{{ page }}</span>
    </div>


    <RouterLink
      v-if="getNextPage() > 0"
      :to="{ name: props.routerName, query: { page: getNextPage(), search: props.termSearch } }"
      class="flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white  rounded-e-lg hover:bg-violet-200 hover:text-violet-600"
    >
      Next
    </RouterLink>
    <span v-else class="flex items-center justify-center px-3 h-10 leading-tight text-gray-500 bg-white  rounded-e-lg hover:bg-gray-100 hover:text-gray-700 disabled">Next</span>
  </ul>
</template>